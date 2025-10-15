//
//  UserRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 10/14/25.
//

import Foundation
import Alamofire

final class UserRepositoryImpl: UserRepositoryProtocol {
    func getUserInfo() async -> AppResult<ApiResponse<UserInfo>> {
        let dataReq = UserApi.getUserInfo()
        return await safeApi(dataReq, decodeTo: ApiResponse<UserInfo>.self)
    }
}
