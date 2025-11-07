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
    
    // ✅ 예치금 거래내역 조회
    func getPaymentTransaction(page: Int, size: Int) async -> AppResult<ApiResponse<PaymentTransactionPageData>> {
        let request = HistoryApi.getPaymentTransaction(page: page, size: size)
        return await safeApi(request, decodeTo: ApiResponse<PaymentTransactionPageData>.self)
    }
}
