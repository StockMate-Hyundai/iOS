//
//  PartApi.swift
//  StockMate
//
//  Created by Admin on 10/31/25.
//


import Foundation
import Alamofire

// ✅ 요청 모델 (partCode → partId 로 변경)
struct ReleaseItemRequest: Encodable {
    let partId: Int
    let quantity: Int
}

// ✅ 부품 상세 정보 모델
struct PartDetailResponse: Decodable {
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
}


// ✅ API 정의
enum PartApi {
    static func releaseParts(items: [ReleaseItemRequest]) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/store/release"
        let body: [String: Any] = [
//            "items": items.map { ["partId": $0.partId, "quantity": $0.quantity] }
            "items": items.map { ["partId": $0.partId, "quantity": $0.quantity] }

        ]
        return ApiClient.shared.request(
            url,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default
        )
    }
    
    // ✅ 부품 상세 조회 API
      static func fetchPartDetail(partId: Int) -> DataRequest {
          let url = ApiClient.baseURL + "api/v1/parts/detail"
          let body: [String: Any] = ["partId": partId]

          return ApiClient.shared.request(
              url,
              method: .post,
              parameters: body,
              encoding: JSONEncoding.default
          )
      }
    
}
