//
//  TokenStore.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import Foundation
import Security

final class TokenStore: @unchecked Sendable {
    static let shared = TokenStore()
    private init() {}

    private let defaults = UserDefaults.standard

    // 토큰 및 역할 저장
    func save(access: String, refresh: String, role: String) {
        defaults.set(role, forKey: "role")
        KeychainHelper.standard.save(access, service: "com.stockmate", account: "accessToken")
        KeychainHelper.standard.save(refresh, service: "com.stockmate", account: "refreshToken")
    }

    // 저장된 토큰 및 역할 제거
    func clear() {
        defaults.removeObject(forKey: "role")
        KeychainHelper.standard.delete(service: "com.stockmate", account: "accessToken")
        KeychainHelper.standard.delete(service: "com.stockmate", account: "refreshToken")
    }

    // 액세스 토큰 조회
    func getAccessToken() -> String? {
        return KeychainHelper.standard.read(service: "com.stockmate", account: "accessToken")
    }

    // 리프레시 토큰 조회
    func getRefreshToken() -> String? {
        return KeychainHelper.standard.read(service: "com.stockmate", account: "refreshToken")
    }

    // 사용자 역할(Role) 조회
    func getRole() -> String? {
        return defaults.string(forKey: "role")
    }
}

