//
//  PartApi.swift
//  StockMate
//
//  Created by Admin on 10/31/25.
//


import Foundation
import Alamofire

// 출고(Release) 요청 시 사용되는 부품 항목 데이터 모델
struct ReleaseItemRequest: Encodable {
    let partId: Int
    let quantity: Int
}

// 부품 상세 정보 응답
struct PartDetailResponse: Decodable, Identifiable {
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

// 사용처리 임시 값
struct PartDetail: Identifiable {
    let id: Int
    let price: Int
    let image: String
    let trim: String
    let model: String
    let korName: String
    let categoryName: String
    var quantity: Int = 1
}


// API
enum PartApi {
    static func releaseParts(items: [ReleaseItemRequest]) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/store/release"
        let body: [String: Any] = [
            "items": items.map { ["partId": $0.partId, "quantity": $0.quantity] }

        ]
        return ApiClient.shared.request(
            url,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default
        )
    }
  
    // 부품 상세 조회 API
    static func fetchPartDetail(partIds: [Int]) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/parts/detail"
        
        // 요청 본문은 단순 배열 형태이므로 parameters 사용 X, 직접 body에 encode
        return ApiClient.shared.request(
            url,
            method: .post,
            parameters: partIds,
            encoder: JSONParameterEncoder.default
        )
    }
}
