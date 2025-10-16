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
}
