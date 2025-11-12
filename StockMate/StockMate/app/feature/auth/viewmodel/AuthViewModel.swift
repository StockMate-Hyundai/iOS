//
//  AuthViewModel.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import SwiftUI

// 인증 상태를 나타내는 enum
enum AuthState {
    case unauthenticated
    case registering
    case authenticated
}

// 인증 관련 로직(ViewModel)
@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var message: String = ""
    @Published var authState: AuthState = .unauthenticated

    // MARK: - Dependencies
    private let repo: AuthRepositoryProtocol

    // MARK: - Init
    init(repo: AuthRepositoryProtocol = AuthRepositoryImpl()) {
        self.repo = repo
    }

    // MARK: - 로그인
    func login() async  -> Bool{
        print("로그인 시도 - email: \(email), password: \(password)")
        let req = LoginRequest(email: email, password: password)
        let result = await repo.login(req)
        print("로그인 응답 도착: \(result)")

        switch result {
        case .success(let apiResp):
            guard let data = apiResp.data else {
                print("데이터 없음: \(apiResp.message)")
                message = apiResp.message
                return false
            }
            TokenStore.shared.save(
                access: data.accessToken,
                refresh: data.refreshToken,
                role: data.role
            )
            message = "로그인 성공"
            authState = .authenticated
            print("authState 변경됨 → authenticated")
            return true

        case .failure(let err):
            print("로그인 실패: \(err.message)")
            message = err.message
            return false
        }
    }

    // MARK: - 로그아웃
    func logout() {
        TokenStore.shared.clear()
        authState = .unauthenticated
    }
    
    // MARK: - 화면 상태 전환
    func goToLogin() {
        authState = .unauthenticated
    }

    func goToRegister() {
        authState = .registering
    }

    // MARK: - 회원가입
    func register(
        email: String,
        password: String,
        owner: String,
        address: String,
        storeName: String,
        bizNo: String
    ) async -> Bool {
        
        let req = RegisterRequest(
            email: email,
            password: password,
            owner: owner,
            address: address,
            storeName: storeName,
            businessNumber: bizNo
        )

        let result = await repo.register(req)
        print("회원가입 응답 도착: \(result)")
        switch result {
        case .success(let apiResp):
            message = apiResp.message
            authState = .unauthenticated
            return true
        case .failure(let err):
            message = err.message
            return false
        }
    }

}
