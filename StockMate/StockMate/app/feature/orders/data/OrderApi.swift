//
//  OrderApi.swift
//  StockMate
//
//  Created by Admin on 10/21/25.
//

import Foundation
import Alamofire

// MARK: - Response Models

struct OrderListResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: OrderPageData?
}

struct OrderDetailResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: OrderResponseItem?
}


struct OrderPageData: Decodable {
    let totalElements: Int
    let totalPages: Int
    let page: Int
    let size: Int
    let content: [OrderResponseItem]
    let last: Bool
}

struct OrderResponseItem: Decodable, Identifiable {
    var id: Int { orderId }

    let orderId: Int
    let orderNumber: String
    let memberId: Int
    let userInfo: OrderUserInfo?
    let orderItems: [OrderItem]
    let paymentType: String?
    let etc: String?
    let rejectedMessage: String?
    let carrier: String?
    let trackingNumber: String?
    let requestedShippingDate: String?
    let shippingDate: String?
    let totalPrice: Int
    let orderStatus: String
    let createdAt: String
    let updatedAt: String
}

struct OrderUserInfo: Decodable {
    let id: Int
    let memberId: Int
    let email: String
    let owner: String
    let address: String
    let storeName: String
    let businessNumber: String
    let role: String
    let verified: String
    let latitude: Double
    let longitude: Double
}

struct OrderItem: Decodable {
    let partId: Int
    let amount: Int
    let partDetail: OrderPartDetail
}

struct OrderPartDetail: Decodable {
    let id: Int
    let name: String
    let price: Int
    let image: String
    let trim: String
    let model: String
    let category: Int
    let korName: String
    let engName: String
    let categoryName: String
    let amount: Int
}


// MARK: - 주문 생성 Request
struct OrderRequest: Encodable {
    let orderItems: [OrderItems]
    let requestedShippingDate: String
    let paymentType: String
    let etc: String
}

struct OrderItems: Encodable {
    let partId: Int
    let amount: Int
}

struct OrderCreateResponseData: Decodable {
    let orderId: Int
    let orderNumber: String
    let totalPrice: Int
    let paymentType: String // ✅ 서버 필드와 맞춤
}

// ✅ 입고 처리 요청 API
struct ReceiveOrderRequest: Encodable {
    let orderNumber: String
}


// MARK: - API Call

enum OrderApi {
    // ✅ 내 주문 리스트 조회 API
    static func getMyOrderList(
        status: String? = nil,
        startDate: String? = nil,
        endDate: String? = nil,
        page: Int = 0,
        size: Int = 20
    ) -> DataRequest {
        var url = ApiClient.baseURL + "api/v1/order/list/my?page=\(page)&size=\(size)"
        
        if let status = status, !status.isEmpty {
            url += "&status=\(status.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        if let startDate = startDate, !startDate.isEmpty {
            url += "&startDate=\(startDate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        if let endDate = endDate, !endDate.isEmpty {
            url += "&endDate=\(endDate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        
        return ApiClient.shared.request(url, method: .get)
    }
    
    
    // ✅ 주문 상세 조회 API
    static func getOrderDetail(orderId: Int) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/detail?orderId=\(orderId)"
        return ApiClient.shared.request(url, method: .get)
    }
    
    
    // ✅ 주문 생성 API
    static func createOrder(_ requestBody: OrderRequest) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order"
        return ApiClient.shared.request(
            url,
            method: .post,
            parameters: requestBody,
            encoder: JSONParameterEncoder.default
        )
    }
 
    // ✅ 주문 취소 API
    static func cancelOrder(orderId: Int) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/\(orderId)/cancel"
        print("🚀 CancelOrder URL:", url)
        return ApiClient.shared.request(url, method: .put)
            .validate() // ✅ 서버 상태코드 확인
    }
    
    // ✅ 입고 처리 API
    static func receiveOrder(_ requestBody: ReceiveOrderRequest) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/receive"
        return ApiClient.shared.request(
            url,
            method: .post,
            parameters: requestBody,
            encoder: JSONParameterEncoder.default
        )
    }
}
