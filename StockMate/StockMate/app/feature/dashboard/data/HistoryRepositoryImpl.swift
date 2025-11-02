//
//  HistoryRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 11/1/25.
//

import Foundation
import Alamofire

final class HistoryRepositoryImpl: HistoryRepositoryProtocol {
    func getInOutHistory(page: Int, size: Int) async -> AppResult<ApiResponse<HistoryPageData>> {
        let request = HistoryApi.getInOutHistory(page: page, size: size)
        return await safeApi(request, decodeTo: ApiResponse<HistoryPageData>.self)
    }
}
