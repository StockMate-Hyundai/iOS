//
//  PaymentRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 10/29/25.
//


import Foundation
import Alamofire


final class PaymentRepositoryImpl: PaymentRepositoryProtocol {
    
    func fetchDepositAmount() async -> AppResult<PaymentAmount> {
        let request = PaymentApi.getPaymentAmount()
        let result = await safeApi(request, decodeTo: ApiResponse<PaymentAmount>.self)

        switch result {
        case .success(let response):
            if let data = response.data {
                return .success(data)
            } else {
                return .failure(.init(
                    code: response.status,
                    message: response.message,
                    underlying: nil
                ))
            }

        case .failure(let error):
            return .failure(error)
        }
    }
    
    func chargeDeposit(amount: Int) async -> AppResult<String> {
        let request = PaymentApi.chargeDeposit(amount: amount)
        let result = await safeApi(request, decodeTo: ApiResponse<String>.self)

        switch result {
        case .success(let response):
            return .success(response.data ?? response.message)

        case .failure(let error):
            return .failure(error)
        }
    }
    
    // ✅ 최근 5개월 소비 내역 조회
    func fetchMonthlySpending() async -> AppResult<[MonthlySpending]> {
        let request = PaymentApi.getMonthlySpending()
        let result = await safeApi(request, decodeTo: ApiResponse<[MonthlySpending]>.self)
        switch result {
        case .success(let response):
            if let data = response.data {
                return .success(data)
            } else {
                return .failure(.init(code: response.status, message: response.message, underlying: nil))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
