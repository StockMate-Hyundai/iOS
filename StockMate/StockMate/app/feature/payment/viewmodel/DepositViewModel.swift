//
//  PaymentViewModel.swift
//  StockMate
//
//  Created by Admin on 10/29/25.
//

import Foundation

@MainActor
final class DepositViewModel: ObservableObject {
    private let repository: PaymentRepositoryProtocol = PaymentRepositoryImpl()
    
    @Published var balance: Int = 0
    @Published var isLoading: Bool = false
    @Published var showChargeSheet: Bool = false
    
    @Published var depositAmount: Int = 0
    @Published var isChargeSuccess: Bool = false
    
    /// ✅ 예치금 조회
    func fetchDepositAmount() async {
        isLoading = true
        
        let result = await repository.fetchDepositAmount()
        
        isLoading = false
        
        switch result {
        case .success(let data):
            self.balance = data.balance
        case .failure(let error):
            print("❌ 예치금 조회 실패:", error.message)
        }
    }
    
    /// ✅ 예치금 충전
    func chargeDeposit(amount: Int) async -> Bool {
         let result = await repository.chargeDeposit(amount: amount)
         switch result {
         case .success(_):
             await fetchDepositAmount()
             isChargeSuccess = true
             return true
         case .failure(let error):
             print("❌ 충전 실패:", error.message)
             return false
         }
     }
}
