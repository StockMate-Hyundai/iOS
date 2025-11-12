//
//  OrderViewModel.swift
//  StockMate
//
//  Created by Admin on 10/21/25.
//

import Foundation

@MainActor
final class OrderViewModel: ObservableObject {
    @Published var orders: [OrderResponseItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var isOrderSuccess: Bool = false
    @Published var isOrderCanceled: Bool = false
    
    @Published var createdOrderId: Int?
    
    private let repository: OrderRepositoryProtocol

    init(repository: OrderRepositoryProtocol = OrderRepositoryImpl()) {
        self.repository = repository
    }
    // MARK: - 주문 목록 조회
    func loadOrders(
        status: String? = nil,
        startDate: String? = nil,
        endDate: String? = nil,
        page: Int = 0,
        size: Int = 20
    ) async {
        isLoading = true
        defer { isLoading = false }

        let result = await repository.fetchMyOrders(
            status: status,
            startDate: startDate,
            endDate: endDate,
            page: page,
            size: size
        )

        switch result {
        case .success(let pageData):
            orders = pageData.content
        case .failure(let error):
            errorMessage = error.message
        }
    }
    
    // MARK: - 주문 생성
    func createOrder(request: OrderRequest) async {
        let result = await repository.createOrder(request: request)

        switch result {
        case .success(let response):
            self.createdOrderId = response.orderId
            self.isOrderSuccess = true

        case .failure(let error):
            print("주문 실패:", error.message)
            self.errorMessage = error.message
        }
    }


    // MARK: - 주문 취소
    func cancelOrder(orderId: Int) async {
        isLoading = true
        let result = await repository.cancelOrder(orderId: orderId)
        
        switch result {
        case .success:
            await loadOrders()      // 취소 후 즉시 UI 새로고침
        case .failure(let error):
            errorMessage = error.message
        }
        isLoading = false
    }
    
    // MARK: - 입고 처리 (주문 수령)
    func receiveOrder(orderNumber: String) async -> AppResult<String> {
        isLoading = true
        defer { isLoading = false }

        let result = await repository.receiveOrder(orderNumber: orderNumber)
        switch result {
        case .success(let message):
            print("입고 처리 성공:", message)
            await loadOrders()
            return .success(message)
        case .failure(let error):
            errorMessage = error.message
            return .failure(error)
        }
    }
}
