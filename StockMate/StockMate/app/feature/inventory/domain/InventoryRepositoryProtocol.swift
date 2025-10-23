//
//  InventoryRepositoryProtocol.swift
//  StockMate
//
//  Created by Admin on 10/15/25.
//

import Foundation

protocol InventoryRepositoryProtocol {
    func getInventoryList(
        page: Int,
        size: Int,
        categoryNames: [String],
        trims: [String],
        models: [String]
    ) async -> AppResult<ApiResponse<InventoryPageData>>
    
    func getUnderLimitList(
        categoryName: String?,
        page: Int,
        size: Int
    ) async -> AppResult<ApiResponse<InventoryPageData>>
    
    // 이름 검색
    func findByName(
        name: String,
        page: Int,
        size: Int
    ) async -> AppResult<ApiResponse<InventoryPageData>>

    func getLackCountByCategory() async -> AppResult<ApiResponse<[LackCountItem]>>

}
