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
    
    // 주문 생성
    func createOrder(request: OrderRequest) async {
        let result = await repository.createOrder(request: request)

        switch result {
        case .success(let response):
            self.createdOrderId = response.orderId
            self.isOrderSuccess = true

        case .failure(let error):
            print("❌ 주문 실패:", error.message)
            self.errorMessage = error.message
        }
    }


    func cancelOrder(orderId: Int) async {
        isLoading = true
        let result = await repository.cancelOrder(orderId: orderId)
        
        switch result {
        case .success:
            await loadOrders()      // ✅ 취소 후 즉시 UI 새로고침
        case .failure(let error):
            errorMessage = error.message
        }
        isLoading = false
    }


}
