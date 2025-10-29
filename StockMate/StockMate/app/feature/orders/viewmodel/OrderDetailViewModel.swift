//
//  OrderDetailViewModel.swift
//  StockMate
//
//  Created by Admin on 10/22/25.
//

import Foundation

@MainActor
final class OrderDetailViewModel: ObservableObject {
    @Published var order: OrderResponseItem?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository = OrderRepositoryImpl()

    func fetchOrderDetail(orderId: Int) async {
        isLoading = true
        defer { isLoading = false }

        let result = await repository.fetchOrderDetail(orderId: orderId)

        switch result {
        case .success(let detail):
            self.order = detail
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }
}
