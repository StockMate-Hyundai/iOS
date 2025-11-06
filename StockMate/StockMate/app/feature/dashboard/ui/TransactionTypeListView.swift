//
//  TransactionTypeListView.swift
//  StockMate
//
//  Created by Admin on 11/6/25.
//

import SwiftUI

struct TransactionTypeListView: View {
    @StateObject private var viewModel = HistoryViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.transactions, id: \.id) { item in
                HStack {
                    // 대표 이미지
                    AsyncImage(url: URL(string: item.orderItems?.first?.image ?? "")) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        Image("exchange")
                            .foregroundColor(Color.Primary)
                    }
                    .frame(width: 64, height: 64)
                    .cornerRadius(10)
                    

                    VStack (alignment: .leading, spacing: 3){
                        
                        // ✅ PAY/CHARGE 별 상세 표시 (부품 이름/ 예치금 충전)
                        if item.transactionType == "PAY",
                           let orderItems = item.orderItems,
                           !orderItems.isEmpty {
                            let firstName = orderItems.first?.korName ?? "-"
                            let extraCount = orderItems.count - 1
                            let displayText = extraCount > 0
                                ? "\(firstName) 외 \(extraCount)개"
                                : firstName

                            Text(displayText)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        } else if item.transactionType == "CHARGE" {
                            Text("예치금 충전")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        
                        // ✅ 거래 시간 (포맷 적용)
                        if let time = item.transactionTime {
                            Text(formattedDate(time))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        } else {
                            Text("-")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        
                        // ✅ 거래 금액 표시 (CHARGE: +파란색 / PAY: -빨간색)
                        let sign = item.transactionType == "PAY" ? "-" : "+"
                        let color: Color = item.transactionType == "PAY" ? .Danger : .Primary

                        Text("\(sign) \(formatPrice(item.totalAmount))")
                            .font(.headline)
                            .foregroundColor(color)
                            .frame(alignment: .trailing)

                    }
                    Spacer()
                    
                    if item.transactionType == "PAY" {
                        NavigationLink(destination: ReceiptView(orderId: item.orderId ?? 1)) {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                }
                .padding(.vertical, 4)
                .task {
                    // ✅ 스크롤 시 끝 근처에서 다음 페이지 로드
                    await viewModel.loadMoreTransactionsIfNeeded(currentItem: item)
                }
                
            }
            .background(Color.Light)
            .navigationTitle("예치금 히스토리")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                if viewModel.isTransactionLoading && viewModel.transactions.isEmpty {
                    ProgressView("불러오는 중...")
                }
            }
            .task {
                if viewModel.transactions.isEmpty {
                    await viewModel.fetchPaymentTransactions()
                }
            }
        }
    }
}

#Preview {
    TransactionTypeListView()
}
