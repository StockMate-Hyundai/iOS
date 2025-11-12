//
//  CartRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 10/25/25.
//


import Foundation
import Alamofire

// 장바구니 관련 API 통신을 수행하는 Repository 구현체
final class CartRepositoryImpl: CartRepositoryProtocol {

    // MARK: - 장바구니 조회
    func fetchCart() async -> AppResult<ApiResponse<CartData>> {
        let req = CartApi.fetchCart()
        return await safeApi(req, decodeTo: ApiResponse<CartData>.self)
    }

    // MARK: - 장바구니 추가
    func addToCart(
        request: CartUpdateRequest
    ) async -> AppResult<ApiResponse<CartData>> {
        let req = CartApi.addToCart(request)
        return await safeApi(req, decodeTo: ApiResponse<CartData>.self)
    }

    // MARK: - 장바구니 수정
    func updateCart(
        request: CartUpdateRequest
    ) async -> AppResult<ApiResponse<CartData>> {
        let req = CartApi.updateCart(request)
        return await safeApi(req, decodeTo: ApiResponse<CartData>.self)
    }

    // MARK: - 장바구니 비우기
    func clearCart() async -> AppResult<ApiResponse<VoidData>> {
        let req = CartApi.clearCart()
        return await safeApi(req, decodeTo: ApiResponse<VoidData>.self)
    }
}
