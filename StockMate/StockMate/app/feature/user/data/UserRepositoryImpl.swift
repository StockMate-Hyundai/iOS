//
//  UserRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 10/14/25.
//

import Foundation
import Alamofire

// MARK: - 사용자 관련 Repository 구현체
final class UserRepositoryImpl: UserRepositoryProtocol {
    // 사용자 정보 조회
    func getUserInfo() async -> AppResult<ApiResponse<UserInfo>> {
        let dataReq = UserApi.getUserInfo()
        return await safeApi(dataReq, decodeTo: ApiResponse<UserInfo>.self)
    }
}
