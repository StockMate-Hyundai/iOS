//
//  PartApi.swift
//  StockMate
//
//  Created by Admin on 10/31/25.
//


import Foundation
import Alamofire

// ✅ 요청 모델
struct ReleaseItemRequest: Encodable {
    let partCode: String
    let quantity: Int
}

// ✅ API 정의
enum PartApi {
    static func releaseParts(items: [ReleaseItemRequest]) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/store/release"
        let body: [String: Any] = [
            "items": items.map { ["partCode": $0.partCode, "quantity": $0.quantity] }
        ]
        return ApiClient.shared.request(
            url,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default
        )
    }
}
