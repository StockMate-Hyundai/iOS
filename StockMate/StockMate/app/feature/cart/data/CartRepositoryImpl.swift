//
//  CartRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 10/25/25.
//


import Foundation
import Alamofire

final class CartRepositoryImpl: CartRepositoryProtocol {

    func fetchCart() async -> AppResult<ApiResponse<CartData>> {
        let req = CartApi.fetchCart()
        return await safeApi(req, decodeTo: ApiResponse<CartData>.self)
    }

    func addToCart(
        request: CartUpdateRequest
    ) async -> AppResult<ApiResponse<CartData>> {
        let req = CartApi.addToCart(request)
        return await safeApi(req, decodeTo: ApiResponse<CartData>.self)
    }

    func updateCart(
        request: CartUpdateRequest
    ) async -> AppResult<ApiResponse<CartData>> {
        let req = CartApi.updateCart(request)
        return await safeApi(req, decodeTo: ApiResponse<CartData>.self)
    }

    func clearCart() async -> AppResult<ApiResponse<VoidData>> {
        let req = CartApi.clearCart()
        return await safeApi(req, decodeTo: ApiResponse<VoidData>.self)
    }
    
}
