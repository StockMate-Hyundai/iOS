//
//  HistoryRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 11/1/25.
//

import Foundation
import Alamofire

// === Repository Implementation ===
// 입출고 및 예치금 거래내역 데이터 요청을 처리하는 구현체
final class HistoryRepositoryImpl: HistoryRepositoryProtocol {
    // GET - 입출고 히스토리 조회
    func getInOutHistory(page: Int, size: Int) async -> AppResult<ApiResponse<HistoryPageData>> {
        let request = HistoryApi.getInOutHistory(page: page, size: size)
        return await safeApi(request, decodeTo: ApiResponse<HistoryPageData>.self)
    }
    
    // GET - 예치금 거래내역 조회
    func getPaymentTransaction(page: Int, size: Int) async -> AppResult<ApiResponse<PaymentTransactionPageData>> {
        let request = HistoryApi.getPaymentTransaction(page: page, size: size)
        return await safeApi(request, decodeTo: ApiResponse<PaymentTransactionPageData>.self)
    }
}
