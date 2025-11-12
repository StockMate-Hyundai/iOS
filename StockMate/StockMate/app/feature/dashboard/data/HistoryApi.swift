//
//  HistoryApi.swift
//  StockMate
//
//  Created by Admin on 11/1/25.
//

import Foundation
import Alamofire

// === Response ===
// 입출고 히스토리 페이지 데이터
struct HistoryPageData: Decodable {
    let totalElements: Int
    let totalPages: Int
    let currentPage: Int
    let pageSize: Int
    let content: [HistoryItem]
    let last: Bool
}

// 입출고 히스토리 단일 항목
struct HistoryItem: Decodable, Identifiable {
    let id: Int
    let memberId: Int
    let orderId: Int?
    let orderNumber: String?
    let message: String
    let status: String
    let type: String
    let createdAt: String
    let updatedAt: String
    let userInfo: HistoryUserInfo?
    let items: [HistoryPart]
}

// 입출고 히스토리에 포함된 사용자 정보
struct HistoryUserInfo: Decodable {
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

// 입출고 히스토리에 포함된 부품 정보
struct HistoryPart: Decodable, Identifiable {
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
    let code: String
    let location: String
    let cost: Int
    let historyQuantity: Int
}


// === 예치금 거래내역 ===
// 예치금 거래내역 페이지 데이터
struct PaymentTransactionPageData: Decodable {
    let content: [PaymentTransactionItem]
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
    let hasNext: Bool
    let hasPrevious: Bool
    let last: Bool
    let first: Bool
}

// 예치금 거래내역 단일 항목
struct PaymentTransactionItem: Decodable {
    let transactionId: Int
    let transactionType: String    // "CHARGE" or "PAY"
    let transactionTime: String?
    let totalAmount: Int
    let orderId: Int?
    let orderItems: [OrderItemHistory]?
    let balance: Int
}

// 거래내역에 포함된 주문 항목
struct OrderItemHistory: Decodable {
    let id: Int
    let name: String
    let image: String
    let korName: String
    let categoryName: String
}


// === API ===
// 입출고 및 거래내역 관련 API 모음
enum HistoryApi {
    // GET - 가맹점별 입출고 히스토리 조회
    static func getInOutHistory(page: Int = 0, size: Int = 20) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/information/order-history/my?page=\(page)&size=\(size)"
        return ApiClient.shared.request(url, method: .get)
    }
    
    // GET - 예치금 거래내역 조회
    static func getPaymentTransaction(page: Int = 0, size: Int = 20) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/payment/transaction?page=\(page)&size=\(size)"
        return ApiClient.shared.request(url, method: .get)
    }
}
