//
//  AppResult.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import Foundation

enum AppResult<T> {
    case success(T)
    case failure(AppError)
}

struct AppError: Error {
    let code: Int?
    let message: String
    let underlying: Error?
}
