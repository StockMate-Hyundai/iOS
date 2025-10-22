//
//  OrderRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 10/21/25.
//

import Foundation
import Alamofire

final class OrderRepositoryImpl: OrderRepositoryProtocol {
    func fetchMyOrders(
        status: String?,
        startDate: String?,
        endDate: String?,
        page: Int,
        size: Int
    ) async -> AppResult<OrderPageData> {
        let request = OrderApi.getMyOrderList(
            status: status,
            startDate: startDate,
            endDate: endDate,
            page: page,
            size: size
        )

        // safeApi 으로 전체 ApiResponse<OrderListResponse> 를 디코딩
        let result = await safeApi(request, decodeTo: OrderListResponse.self)

        switch result {
        case .success(let response):
            // response.data 는 OrderPageData? 이므로 안전하게 꺼내서 반환
            if let pageData = response.data {
                return .success(pageData)
            } else {
                // 서버가 data를 비워서 보냈다면 메시지로 실패 처리
                return .failure(AppError(code: response.status, message: response.message, underlying: nil))
            }

        case .failure(let error):
            return .failure(error)
        }
    }
    
    
    func fetchOrderDetail(orderId: Int) async -> AppResult<OrderResponseItem> {
        let request = OrderApi.getOrderDetail(orderId: orderId)
        let result = await safeApi(request, decodeTo: OrderDetailResponse.self) // ✅ 올바른 타입으로 변경

        switch result {
        case .success(let response):
            if let data = response.data {
                return .success(data)
            } else {
                return .failure(.init(code: -1, message: "주문 상세 데이터를 불러오지 못했습니다.", underlying: nil)) // ✅ 누락된 인자 채움
            }
        case .failure(let error):
            return .failure(error)
        }
    }

}
