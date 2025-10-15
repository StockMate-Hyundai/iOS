//
//  UserRepositoryProtocol.swift
//  StockMate
//
//  Created by Admin on 10/14/25.
//

import Foundation

protocol UserRepositoryProtocol {
    func getUserInfo() async -> AppResult<ApiResponse<UserInfo>>
}
