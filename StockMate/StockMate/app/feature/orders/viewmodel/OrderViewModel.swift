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
}
