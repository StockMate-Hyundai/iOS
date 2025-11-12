//
//  UserRepositoryProtocol.swift
//  StockMate
//
//  Created by Admin on 10/14/25.
//

import Foundation

protocol UserRepositoryProtocol {
    // 사용자 정보 조회
    func getUserInfo() async -> AppResult<ApiResponse<UserInfo>>
}
