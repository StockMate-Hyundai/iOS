//
//  HistoryRepositoryProtocol.swift
//  StockMate
//
//  Created by Admin on 11/1/25.
//

import Foundation
import Alamofire

protocol HistoryRepositoryProtocol {
    func getInOutHistory(page: Int, size: Int) async -> AppResult<ApiResponse<HistoryPageData>>
}
