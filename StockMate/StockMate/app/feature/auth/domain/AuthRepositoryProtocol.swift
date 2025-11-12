//
//  AuthRepositoryProtocol.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import Foundation
import Alamofire

protocol AuthRepositoryProtocol {
    // 회원가입 요청
    func register(_ req: RegisterRequest) async -> AppResult<ApiResponse<Empty>>
    
    // 로그인 요청
    func login(_ req: LoginRequest) async -> AppResult<ApiResponse<LoginData>>
}
