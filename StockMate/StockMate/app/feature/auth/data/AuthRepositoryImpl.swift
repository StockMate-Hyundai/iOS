//
//  AuthRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import Foundation
import Alamofire

//final class AuthRepositoryImpl: AuthRepositoryProtocol {
//    func register(_ req: RegisterRequest) async -> AppResult<ApiResponse<Empty?>> {
//        let dataReq = AuthApi.register(req)
//        return await safeApi(dataReq, decodeTo: ApiResponse<Empty?>.self)
//    }
//
//    func login(_ req: LoginRequest) async -> AppResult<ApiResponse<LoginData?>> {
//        let dataReq = AuthApi.login(req)
//        return await safeApi(dataReq, decodeTo: ApiResponse<LoginData?>.self)
//    }
//}
final class AuthRepositoryImpl: AuthRepositoryProtocol {
    func register(_ req: RegisterRequest) async -> AppResult<ApiResponse<Empty>> {
        let dataReq = AuthApi.register(req)
        return await safeApi(dataReq, decodeTo: ApiResponse<Empty>.self)
    }

    func login(_ req: LoginRequest) async -> AppResult<ApiResponse<LoginData>> {
        let dataReq = AuthApi.login(req)
        return await safeApi(dataReq, decodeTo: ApiResponse<LoginData>.self)
    }
}
