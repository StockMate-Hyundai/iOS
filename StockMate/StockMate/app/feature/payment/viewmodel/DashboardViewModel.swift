//
//  DashboardViewModel.swift
//  StockMate
//
//  Created by Admin on 11/2/25.
//

import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    private let repo: PaymentRepositoryProtocol = PaymentRepositoryImpl()
    
    @Published var monthlySpendings: [MonthlySpending] = []
    @Published var categorySpendings: [CategorySpending] = []
    
    @Published var isLoading = false
    
    // 최근 5개월 소비 내역 조회
    func fetchMonthlySpending() async {
        isLoading = true
        let result = await repo.fetchMonthlySpending()
        isLoading = false
        
        switch result {
        case .success(let data):
            monthlySpendings = data
        case .failure(let err):
            print("❌ 월별 소비 내역 조회 실패:", err.message)
        }
    }
    
    // 지난달 카테고리별 지출 금액 조회
    func fetchCategorySpending() async {
        isLoading = true
        let result = await repo.fetchCategorySpending()
        isLoading = false
          
        switch result {
        case .success(let data):
            categorySpendings = data
        case .failure(let err):
            print("❌ 카테고리별 지출 금액 조회 실패:", err.message)
        }
    }
    
    // 막대그래프 비율 계산
    var spendingRatios: [CGFloat] {
        guard let max = monthlySpendings.map({ $0.totalAmount }).max(), max > 0 else { return [] }
        return monthlySpendings.map { CGFloat($0.totalAmount) / CGFloat(max) }
    }

    // 월 라벨 (예: "10월", "11월")
    var monthLabels: [String] {
        monthlySpendings.map { month in
            // "2025-10" → "10월"
            if month.month.count >= 7 {
                let suffix = String(month.month.suffix(2))
                if let monthInt = Int(suffix) {
                    return "\(monthInt)월"
                } else {
                    return suffix + "월"
                }
            } else {
                return month.month
            }
        }
    }
}
