//
//  AuthApi.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import Foundation
import Alamofire

// === Request ===
// 회원가입 요청 바디
struct RegisterRequest: Encodable {
    let email: String
    let password: String
    let owner: String
    let address: String
    let storeName: String
    let businessNumber: String
}
// 로그인 요청 바디
struct LoginRequest: Encodable {
    let email: String
    let password: String
}


// === Response ===
// 회원가입 응답
struct RegisterResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
}

// 로그인 응답 데이터
struct LoginData: Decodable {
    let accessToken: String
    let refreshToken: String
    let role: String
}

// 로그인 응답 전체 구조
struct LoginResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: LoginData?
}

// === API ===
// 인증 관련 API 모음
enum AuthApi {
    // POST - 회원가입 요청
    static func register(_ req: RegisterRequest) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/auth/register"
        return ApiClient.shared.request(url, method: .post, parameters: req, encoder: JSONParameterEncoder.default)
    }

    // POST - 로그인 요청
    static func login(_ req: LoginRequest) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/auth/login"
        return ApiClient.shared.request(url, method: .post, parameters: req, encoder: JSONParameterEncoder.default)
    }
}
