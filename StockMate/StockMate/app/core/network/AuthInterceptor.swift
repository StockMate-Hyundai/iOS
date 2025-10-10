//
//  AuthInterceptor.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor, @unchecked Sendable {
    private let tokenStore = TokenStore.shared

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var req = urlRequest
        if let token = tokenStore.getAccessToken() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(req))
    }

    // 필요 시 retry(_:for:dueTo:completion:) 구현해서 401 -> refresh token 흐름 처리 가능
}
