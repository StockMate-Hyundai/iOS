//
//  UserApi.swift
//  StockMate
//
//  Created by Admin on 10/14/25.
//

import Foundation
import Alamofire

// MARK: - 사용자 정보 응답 모델
struct UserInfoResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: UserInfo?
}

// MARK: - 사용자 정보 모델
struct UserInfo: Decodable {
    let createdAt: String
    let updatedAt: String
    let id: Int
    let memberId: Int
    let email: String
    let owner: String
    let address: String
    let storeName: String
    let businessNumber: String
    let latitude: Double
    let longitude: Double
    let role: String
    let verified: String
}

// MARK: - 사용자 API 요청 정의
enum UserApi {
    static func getUserInfo() -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/user/my"
        return ApiClient.shared.request(url, method: .get)
    }
}
