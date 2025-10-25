//
//  CartViewModel.swift
//  StockMate
//
//  Created by Admin on 10/25/25.
//

import Foundation

@MainActor
final class CartViewModel: ObservableObject {

    @Published var cart: CartData?
    @Published var items: [CartItem] = []
    @Published var message: String = ""
    @Published var isLoading: Bool = false
    @Published var shouldGoToLogin: Bool = false   // 401 대응

    private let repository: CartRepositoryProtocol

    init(repository: CartRepositoryProtocol = CartRepositoryImpl()) {
        self.repository = repository
    }

    // MARK: - Fetch
    func fetchCart() async {
        isLoading = true
        defer { isLoading = false }

        switch await repository.fetchCart() {
        case .success(let response):
            self.cart = response.data
            self.items = response.data?.items ?? []
        case .failure(let error):
            handleError(error)
        }
    }

    // MARK: - Add
    func addToCart(partId: Int, amount: Int) async {
        let req = CartUpdateRequest(items: [CartUpdateItem(partId: partId, amount: amount)])
        switch await repository.addToCart(request: req) {
        case .success(let response):
            self.cart = response.data
            self.items = response.data?.items ?? []
        case .failure(let error):
            handleError(error)
        }
    }

    // MARK: - Update Quantity (전체 덮어쓰기)
    func updateCart() async {
        let requestItems = items.map { CartUpdateItem(partId: $0.partId, amount: $0.amount) }
        let req = CartUpdateRequest(items: requestItems)

        switch await repository.updateCart(request: req) {
        case .success(let response):
            self.cart = response.data
        case .failure(let error):
            handleError(error)
        }
    }

    // MARK: - Clear Cart
    func clearCart() async {
        switch await repository.clearCart() {
        case .success:
            self.cart = nil
            self.items = []
        case .failure(let error):
            handleError(error)
        }
    }

    // MARK: - Private
    private func handleError(_ error: AppError) {
        message = error.message
        if error.code == 401 {
            shouldGoToLogin = true
        }
    }
    
    
    func quantity(for partId: Int) -> Int {
         return items.first(where: { $0.partId == partId })?.amount ?? 0
     }

    func increaseQuantity(for partId: Int) async {
        if let index = items.firstIndex(where: { $0.partId == partId }) {
            items[index].amount += 1
        } else {
            let newItem = CartItem(
                cartItemId: 0,
                partId: partId,
                amount: 1,
                partName: nil,
                categoryName: nil,
                brand: nil,
                model: nil,
                trim: nil,
                price: nil,
                stock: nil
            )
            items.append(newItem)
        }
        await syncCart()
    }

    func decreaseQuantity(for partId: Int) async {
        guard let index = items.firstIndex(where: { $0.partId == partId }) else { return }

        if items[index].amount > 1 {
            items[index].amount -= 1
        } else {
            items.remove(at: index)
        }
        await syncCart()
    }

    
    // 외부에서 호출하는 기존 updateCart()는 그대로 유지
    private func syncCart() async {
        let updates = items.map {
            CartUpdateItem(partId: $0.partId, amount: $0.amount)
        }
        let request = CartUpdateRequest(items: updates)
        let response = await repository.updateCart(request: request)

        if case .success(let result) = response, let data = result.data {
            self.items = data.items  // 서버 최신 값으로 맞추기
        }
    }

    
}
