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
}
