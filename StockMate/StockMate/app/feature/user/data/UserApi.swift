//
//  UserApi.swift
//  StockMate
//
//  Created by Admin on 10/14/25.
//

import Foundation
import Alamofire

struct UserInfoResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: UserInfo?
}

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

enum UserApi {
    static func getUserInfo() -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/user/my"
        return ApiClient.shared.request(url, method: .get)
    }
}
