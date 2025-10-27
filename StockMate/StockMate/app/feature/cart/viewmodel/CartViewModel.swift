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
        case .success:
            await fetchCart()
            updateLocalCartState()
        case .failure(let error):
            handleError(error)
        }
    }

    // MARK: - Update Quantity (전체 덮어쓰기)
    func updateCart() async {
        // ✅ items가 비면 clearCart 호출하고 return
          if items.isEmpty {
              await clearCart()
              return
          }
        
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
        print("🚨 Error (\(error.code)): \(error.message)")
        
        if error.code == 401 {
            shouldGoToLogin = true
        }
    }
    
    func quantity(for partId: Int) -> Int {
        return items.first(where: { $0.partId == partId })?.amount ?? 0
    }

    private func updateLocalCartState() {
        let total = items.reduce(0) { result, item in
            result + (item.price ?? 0) * item.amount
        }

        if let cart = cart {
            self.cart = CartData(
                cartId: cart.cartId,
                memberId: cart.memberId,
                items: self.items,
                totalPrice: total
            )
        } else {
            // fallback: cart가 nil일 수 있는 초기 로드 상황 대비
            self.cart = CartData(
                cartId: -1,
                memberId: -1,
                items: self.items,
                totalPrice: total
            )
        }
        
        objectWillChange.send() // 중요! SwiftUI에게 “바뀌었어!” 알림
    }


    func increaseQuantity(for partId: Int) async {
        if let index = items.firstIndex(where: { $0.partId == partId }) {
            items[index].amount += 1
        } else {
            items.append(CartItem(
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
            ))
        }

        await syncCart()
        updateLocalCartState()
    }

    func decreaseQuantity(for partId: Int) async {
        guard let index = items.firstIndex(where: { $0.partId == partId }) else {
            return
        }

        if items[index].amount > 1 {
            items[index].amount -= 1
        } else {
            items.remove(at: index)
        }

        await syncCart()
        updateLocalCartState()
    }
    
    private func syncCart() async {
        if items.isEmpty {
            // ✅ 장바구니가 빈 경우는 clearCart 호출
            await clearCart()
            return
        }
        let updates = items.map {
            CartUpdateItem(partId: $0.partId, amount: $0.amount)
        }
        let request = CartUpdateRequest(items: updates)

        switch await repository.updateCart(request: request) {
        case .success:
            await fetchCart()
        case .failure(let error):
            handleError(error)
        }
    }

}
