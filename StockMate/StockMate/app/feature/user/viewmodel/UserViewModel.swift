//
//  UserViewModel.swift
//  StockMate
//
//  Created by Admin on 10/14/25.
//

import SwiftUI

@MainActor
final class UserViewModel: ObservableObject {
    @Published var userInfo: UserInfo?
    @Published var message: String = ""
    @Published var shouldGoToLogin: Bool = false

    private let repo: UserRepositoryProtocol

    init(repo: UserRepositoryProtocol = UserRepositoryImpl()) {
        self.repo = repo
    }

    func loadUserInfo() async {
        let result = await repo.getUserInfo()
        switch result {
        case .success(let apiResp):
            if let info = apiResp.data {
                userInfo = info
                print("유저 정보 불러오기 성공:", info)
            } else {
                message = apiResp.message
                print("데이터 없음:", apiResp.message)
            }
        case .failure(let err):
            message = err.message
            print("유저 정보 불러오기 실패:", err.message)
            // ✅ 세션 만료나 인증 문제면 로그인화면으로 유도
            if err.code == 401 || err.code == 403 {
                shouldGoToLogin = true
            }
               
        }
    }
}
