//
//  CartRepositoryProtocol.swift
//  StockMate
//
//  Created by Admin on 10/25/25.
//

import Foundation
import Alamofire

protocol CartRepositoryProtocol {
    func fetchCart() async -> AppResult<ApiResponse<CartData>>
    
    func addToCart(
        request: CartUpdateRequest
    ) async -> AppResult<ApiResponse<CartData>>

    func updateCart(
        request: CartUpdateRequest
    ) async -> AppResult<ApiResponse<CartData>>
    
    func clearCart() async -> AppResult<ApiResponse<VoidData>>
}

