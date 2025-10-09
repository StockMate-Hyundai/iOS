//
//  AuthRepositoryProtocol.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import Foundation
import Alamofire

protocol AuthRepositoryProtocol {
    func register(_ req: RegisterRequest) async -> AppResult<ApiResponse<Empty>>
    func login(_ req: LoginRequest) async -> AppResult<ApiResponse<LoginData>>
}
