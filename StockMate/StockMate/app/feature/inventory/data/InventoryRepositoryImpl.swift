//
//  InventoryRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 10/15/25.
//

import Foundation
import Alamofire

// MARK: - 재고 관련 Repository 구현체
final class InventoryRepositoryImpl: InventoryRepositoryProtocol {
    
    // MARK: 재고 리스트 조회
    func getInventoryList(
        page: Int,
        size: Int,
        categoryNames: [String],
        trims: [String],
        models: [String]
    ) async -> AppResult<ApiResponse<InventoryPageData>> {
        let dataReq = InventoryApi.getInventoryList(
            page: page,
            size: size,
            categoryNames: categoryNames,
            trims: trims,
            models: models
        )
        return await safeApi(dataReq, decodeTo: ApiResponse<InventoryPageData>.self)
    }
    
    // MARK: 부족 재고 목록 조회
    func getUnderLimitList(
        categoryName: String?,
        page: Int,
        size: Int
    ) async -> AppResult<ApiResponse<InventoryPageData>> {
        let dataReq = InventoryApi.getUnderLimitList(categoryName: categoryName, page: page, size: size)
        return await safeApi(dataReq, decodeTo: ApiResponse<InventoryPageData>.self)
    }
    
    // MARK: 부품명 검색
    func findByName(
        name: String,
        page: Int,
        size: Int
    ) async -> AppResult<ApiResponse<InventoryPageData>> {
        let dataReq = InventoryApi.findByName(name: name, page: page, size: size)
        return await safeApi(dataReq, decodeTo: ApiResponse<InventoryPageData>.self)
    }
    
    // MARK: 카테고리별 부족 재고 개수 조회
    func getLackCountByCategory() async -> AppResult<ApiResponse<[LackCountItem]>> {
        let dataReq = InventoryApi.getLackCountByCategory()
        return await safeApi(dataReq, decodeTo: ApiResponse<[LackCountItem]>.self)
    }
}
