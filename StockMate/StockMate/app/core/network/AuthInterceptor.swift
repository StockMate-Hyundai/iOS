//
//  AuthInterceptor.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import Foundation
import Alamofire

// API 요청 시 Access Token을 자동으로 헤더에 추가하는 인터셉터
final class AuthInterceptor: RequestInterceptor, @unchecked Sendable {
    private let tokenStore = TokenStore.shared

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var req = urlRequest
        if let token = tokenStore.getAccessToken() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(req))
    }

    // TODO: 401 Unauthorized 응답 시 Refresh Token을 사용해 토큰 재발급 로직 추가
}
