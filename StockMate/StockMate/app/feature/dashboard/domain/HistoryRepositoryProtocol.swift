//
//  HistoryRepositoryProtocol.swift
//  StockMate
//
//  Created by Admin on 11/1/25.
//

import Foundation
import Alamofire

// === Repository Protocol ===
// 입출고 및 예치금 거래내역 관련 데이터 요청 정의
protocol HistoryRepositoryProtocol {
    
    // GET - 입출고 히스토리 조회
    func getInOutHistory(page: Int, size: Int) async -> AppResult<ApiResponse<HistoryPageData>>
    
    // GET - 예치금 거래내역 조회
     func getPaymentTransaction(page: Int, size: Int) async -> AppResult<ApiResponse<PaymentTransactionPageData>>
}
