//
//  AuthApi.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import Foundation
import Alamofire

struct RegisterRequest: Encodable {
    let email: String
    let password: String
    let owner: String
    let address: String
    let storeName: String
    let businessNumber: String
}
struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct RegisterResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
}

struct LoginData: Decodable {
    let accessToken: String
    let refreshToken: String
    let role: String
}
struct LoginResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: LoginData?
}

enum AuthApi {
    static func register(_ req: RegisterRequest) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/auth/register"
        return ApiClient.shared.request(url, method: .post, parameters: req, encoder: JSONParameterEncoder.default)
    }

    static func login(_ req: LoginRequest) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/auth/login"
        return ApiClient.shared.request(url, method: .post, parameters: req, encoder: JSONParameterEncoder.default)
    }
}
