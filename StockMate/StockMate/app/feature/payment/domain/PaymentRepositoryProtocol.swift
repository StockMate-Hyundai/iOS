//
//  PaymentRepositoryProtocol.swift
//  StockMate
//
//  Created by Admin on 10/29/25.
//

import Foundation
import Alamofire

protocol PaymentRepositoryProtocol {
    func fetchDepositAmount() async -> AppResult<PaymentAmount>
    func chargeDeposit(amount: Int) async -> AppResult<String>
    
    // ✅ 최근 5개월 소비 내역 조회
    func fetchMonthlySpending() async -> AppResult<[MonthlySpending]>
   
    // 지난달 카테고리별 지출
    func fetchCategorySpending() async -> AppResult<[CategorySpending]>
    
}
