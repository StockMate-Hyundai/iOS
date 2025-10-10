//
//  ApiResponse.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import Foundation

struct ApiResponse<T: Decodable>: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: T?
}
