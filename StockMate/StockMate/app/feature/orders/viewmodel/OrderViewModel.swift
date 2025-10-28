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
    func createOrder(request: OrderRequest) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        let result = await repository.createOrder(request: request)
        
        switch result {
        case .success(_):
            isOrderSuccess = true
            return true
        case .failure(let error):
            errorMessage = error.message
            print("❌ 주문 실패:", error.message)
            return false
        }
    }
//    func createOrder(
//         items: [OrderItems],
//         requestedDate: String,
//         payment: String,
//         etc: String
//     ) async {
//         let requestBody = OrderRequest(
//             orderItems: items,
//             requestedShippingDate: requestedDate,
//             paymentType: payment,
//             etc: etc
//         )
//
//         let result = await repository.createOrder(request: requestBody)
//
//         switch result {
//         case .success(let orderNumber):
//             print("✅ 주문 성공:", orderNumber)
//         case .failure(let error):
//             print("❌ 주문 실패:", error.message)
//         }
//     }
}
