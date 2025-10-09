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

    func save(access: String, refresh: String, role: String) {
        defaults.set(role, forKey: "role")
        // access/refresh는 Keychain에 저장하는 걸 권장
        KeychainHelper.standard.save(access, service: "com.stockmate", account: "accessToken")
        KeychainHelper.standard.save(refresh, service: "com.stockmate", account: "refreshToken")
    }

    func clear() {
        defaults.removeObject(forKey: "role")
        KeychainHelper.standard.delete(service: "com.stockmate", account: "accessToken")
        KeychainHelper.standard.delete(service: "com.stockmate", account: "refreshToken")
    }

    func getAccessToken() -> String? {
        return KeychainHelper.standard.read(service: "com.stockmate", account: "accessToken")
    }

    func getRefreshToken() -> String? {
        return KeychainHelper.standard.read(service: "com.stockmate", account: "refreshToken")
    }

    func getRole() -> String? {
        return defaults.string(forKey: "role")
    }
}

