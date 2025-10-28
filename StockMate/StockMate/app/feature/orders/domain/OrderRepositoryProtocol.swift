//
//  OrderRepositoryProtocol.swift
//  StockMate
//
//  Created by Admin on 10/21/25.
//

import Foundation

protocol OrderRepositoryProtocol {
    func fetchMyOrders(
        status: String?,
        startDate: String?,
        endDate: String?,
        page: Int,
        size: Int
    ) async -> AppResult<OrderPageData>
    
    /// 주문 상세 조회
    func fetchOrderDetail(
        orderId: Int
    ) async -> AppResult<OrderResponseItem>
    
    // 주문 생성
    func createOrder(request: OrderRequest) async -> AppResult<String>
}
