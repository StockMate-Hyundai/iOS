//
//  InventoryRepositoryProtocol.swift
//  StockMate
//
//  Created by Admin on 10/15/25.
//

import Foundation
import Alamofire

// MARK: - 재고 관련 Repository 프로토콜
protocol InventoryRepositoryProtocol {
    // MARK: 재고 리스트 조회
    func getInventoryList(
        page: Int,
        size: Int,
        categoryNames: [String],
        trims: [String],
        models: [String]
    ) async -> AppResult<ApiResponse<InventoryPageData>>
    
    // MARK: 부족 재고 목록 조회
    func getUnderLimitList(
        categoryName: String?,
        page: Int,
        size: Int
    ) async -> AppResult<ApiResponse<InventoryPageData>>
    
    // MARK: 부품명 검색
    func findByName(
        name: String,
        page: Int,
        size: Int
    ) async -> AppResult<ApiResponse<InventoryPageData>>

    // MARK: 카테고리별 부족 재고 개수 조회
    func getLackCountByCategory() async -> AppResult<ApiResponse<[LackCountItem]>>

}
