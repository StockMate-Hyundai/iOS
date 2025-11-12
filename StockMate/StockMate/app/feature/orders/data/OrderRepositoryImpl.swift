//
//  OrderRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 10/21/25.
//

import Foundation
import Alamofire

final class OrderRepositoryImpl: OrderRepositoryProtocol {
    
    // 내 주문 목록 조회
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

        // 서버 응답을 OrderListResponse 형태로 디코딩
        let result = await safeApi(request, decodeTo: OrderListResponse.self)

        switch result {
        case .success(let response):
            if let pageData = response.data {   // response.data 는 OrderPageData? 이므로 안전하게 꺼내서 반환
                return .success(pageData)
            } else {
                // data가 없을 경우 서버 메시지로 실패 처리
                return .failure(AppError(code: response.status, message: response.message, underlying: nil))
            }

        case .failure(let error):
            return .failure(error)
        }
    }
    
    // 주문 상세 조회
    func fetchOrderDetail(orderId: Int) async -> AppResult<OrderResponseItem> {
        let request = OrderApi.getOrderDetail(orderId: orderId)
        let result = await safeApi(request, decodeTo: OrderDetailResponse.self)

        switch result {
        case .success(let response):
            if let data = response.data {
                return .success(data)
            } else {
                return .failure(.init(code: -1, message: "주문 상세 데이터를 불러오지 못했습니다.", underlying: nil))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    // 주문 생성
    func createOrder(request: OrderRequest) async -> AppResult<OrderCreateResponseData> {
        let request = OrderApi.createOrder(request)

        let result = await safeApi(request, decodeTo: ApiResponse<OrderCreateResponseData>.self)

        switch result {
        case .success(let response):
            if let data = response.data {
                return .success(data)
            } else {
                return .failure(.init(code: response.status, message: response.message, underlying: nil))
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    // 주문 취소
    func cancelOrder(orderId: Int) async -> AppResult<String> {
        let request = OrderApi.cancelOrder(orderId: orderId)
        let result = await safeApi(request, decodeTo: ApiResponse<String>.self)

        switch result {
        case .success(let response):
            print(" 취소 성공:", response)
            return .success(response.data ?? "success")
        case .failure(let error):
            return .failure(error)
        }
    }

    // 입고 처리
    func receiveOrder(orderNumber: String) async -> AppResult<String> {
        let request = OrderApi.receiveOrder(.init(orderNumber: orderNumber))
        let result = await safeApi(request, decodeTo: ApiResponse<String>.self)

        switch result {
        case .success(let response):
            print("입고 처리 성공:", response)
            return .success(response.data ?? "입고 처리가 완료되었습니다.")
        case .failure(let error):
            print("입고 처리 실패:", error.message)
            return .failure(error)
        }
    }
}
