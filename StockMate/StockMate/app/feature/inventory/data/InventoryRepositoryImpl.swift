//
//  InventoryRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 10/15/25.
//

import Foundation
import Alamofire

final class InventoryRepositoryImpl: InventoryRepositoryProtocol {
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
    // 부족 재고 리스트 호출
    func getUnderLimitList(
        categoryName: String?,
        page: Int,
        size: Int
    ) async -> AppResult<ApiResponse<InventoryPageData>> {
        let dataReq = InventoryApi.getUnderLimitList(categoryName: categoryName, page: page, size: size)
        return await safeApi(dataReq, decodeTo: ApiResponse<InventoryPageData>.self)
    }
    
    // ✅ 이름 검색
    func findByName(
        name: String,
        page: Int,
        size: Int
    ) async -> AppResult<ApiResponse<InventoryPageData>> {
        let dataReq = InventoryApi.findByName(name: name, page: page, size: size)
        return await safeApi(dataReq, decodeTo: ApiResponse<InventoryPageData>.self)
    }

    
}
