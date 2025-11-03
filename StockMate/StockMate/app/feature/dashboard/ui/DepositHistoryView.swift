//
//  DepositHistoryView.swift
//  StockMate
//
//  Created by Admin on 11/3/25.
//

import SwiftUI

struct DepositHistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        VStack {
            // 본문 스크롤
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.transactions) { item in
                        DepositHistoryRow(item: item)
                            .onAppear {
                                Task {
                                    await viewModel.loadMoreTransactionsIfNeeded(currentItem: item)
                                }
                            }
                    }
                    
                    if viewModel.isTransactionLoading {
                        ProgressView()
                            .padding()
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.Light)
            .navigationTitle("예치금 히스토리")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                await viewModel.fetchPaymentTransactions()
            }
        }
        .task {
            await viewModel.fetchPaymentTransactions()
        }
    }
}

// MARK: - 개별 거래 Row
struct DepositHistoryRow: View {
    let item: PaymentTransactionItem
    
    var isCharge: Bool { item.transactionType == "CHARGE" }
    
    var body: some View {
        HStack(alignment: .center, spacing: 13) {
            // 아이콘
            Image(isCharge ? "exchange" : "bag")
                .frame(width: 64, height: 64)
                .foregroundColor(isCharge ? .Primary : .gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(isCharge ? "예치금 충전" : "실린더 어셈블리-브레이크 마스터 외 3개")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                
                Text(formatDate(item.transactionTime ?? ""))
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(formatAmount(item.totalAmount, isCharge: isCharge))
                    .font(.subheadline)
                    .foregroundColor(isCharge ? .Primary : .red)
            }
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Helper
    private func formatAmount(_ amount: Int, isCharge: Bool) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        return (isCharge ? "+ " : "- ") + formatted + "원"
    }
    
    private func formatDate(_ dateString: String) -> String {
        // 서버에서 "2025.10.29 17:32:39" 형식이면 그대로 반환
        // 혹은 ISO8601이면 변환 필요
        if dateString.contains(".") {
            return dateString
        } else {
            let formatter = ISO8601DateFormatter()
            if let date = formatter.date(from: dateString) {
                let displayFormatter = DateFormatter()
                displayFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
                return displayFormatter.string(from: date)
            }
            return dateString
        }
    }
}

// MARK: - Dummy Preview
#Preview {
    VStack(spacing: 16) {
        DepositHistoryRow(
            item: PaymentTransactionItem(
                transactionType: "CHARGE",
                transactionTime: "2025-11-03T09:12:45",
                totalAmount: 50000,
                orderId: nil,
                balance: 50000
            )
        )
        DepositHistoryRow(
            item: PaymentTransactionItem(
                transactionType: "PAY",
                transactionTime: "2025-11-03T14:34:35.608713",
                totalAmount: 49720,
                orderId: 61,
                balance: 4954617
            )
        )
    }
    .padding()
    .background(Color.Light)
}
