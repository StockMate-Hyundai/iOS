//
//  PaymentApi.swift
//  StockMate
//
//  Created by Admin on 10/29/25.
//


import Foundation
import Alamofire


struct PaymentAmount: Decodable {
    let id: Int
    let balance: Int
    let userId: Int
}

// ✅ 월별 소비 내역 구조체
struct MonthlySpending: Decodable, Identifiable {
    var id: String { month } // 리스트에서 사용하기 편하게
    let month: String
    let totalAmount: Int
}


enum PaymentApi {
    // 예치금 조회
    static func getPaymentAmount() -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/payment/amount"
        return ApiClient.shared.request(url, method: .get)
    }
    
    // 예치금 충전
    static func chargeDeposit(amount: Int) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/payment/charge"
        let params: [String: Any] = [
            "amount": amount
        ]
        return ApiClient.shared.request(
            url,
            method: .post,
            parameters: params,
            encoding: URLEncoding.queryString
        )
    }
    
    // ✅ 최근 5개월 소비 내역 조회
    static func getMonthlySpending() -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/payment/monthly-spending"
        return ApiClient.shared.request(url, method: .get)
    }
}
