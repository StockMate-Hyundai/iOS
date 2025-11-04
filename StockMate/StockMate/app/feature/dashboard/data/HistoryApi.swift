//
//  HistoryApi.swift
//  StockMate
//
//  Created by Admin on 11/1/25.
//

import Foundation
import Alamofire

// MARK: - 입출고 히스토리 데이터 구조
struct HistoryPageData: Decodable {
    let totalElements: Int
    let totalPages: Int
    let currentPage: Int
    let pageSize: Int
    let content: [HistoryItem]
    let last: Bool
}

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


// MARK: - 예치금 거래내역 데이터 구조
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

struct PaymentTransactionItem: Decodable, Identifiable {
    var id: UUID { UUID() } // 서버에서 id 제공 안하므로 로컬 생성
    let transactionType: String    // "CHARGE" or "PAY"
    let transactionTime: String?   // ✅ null 허용
    let totalAmount: Int
    let orderId: Int?              // ✅ null 허용
    let balance: Int
}



// MARK: - API
enum HistoryApi {
    // ✅ 가맹점별 입출고 히스토리 조회
    static func getInOutHistory(page: Int = 0, size: Int = 20) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/information/order-history/my?page=\(page)&size=\(size)"
        return ApiClient.shared.request(url, method: .get)
    }
    
    // ✅ 예치금 거래내역 조회
    static func getPaymentTransaction(page: Int = 0, size: Int = 20) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/payment/transaction?page=\(page)&size=\(size)"
        return ApiClient.shared.request(url, method: .get)
    }
}
