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
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.transactions, id: \.transactionId) { item in
                        TransactionCard(item: item)
                            .onAppear {
                                Task {
                                    await viewModel.loadMoreTransactionsIfNeeded(currentItem: item)
                                }
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
            .background(Color.Light.ignoresSafeArea())
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
        .background(Color.Light)
    }
}

struct TransactionCard: View {
    let item: PaymentTransactionItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 12) {
                
                // PAY일 때만 부품 이미지 표시
                 if item.transactionType == "PAY" {
                     // 대표 이미지
                     AsyncImage(url: URL(string: item.orderItems?.first?.image ?? "")) { image in
                         image.resizable().scaledToFit()
                     } placeholder: {
                             Color.gray.opacity(0.2)
                     }
                     .frame(width: 64, height: 64)
                     .cornerRadius(10)
                 } else {
                     Image("exchange")
                         .foregroundColor(Color.Primary)
                         .frame(width: 64, height: 64)
                         .cornerRadius(10)
                 }
                
               

                VStack(alignment: .leading, spacing: 5) {
                    if item.transactionType == "PAY",
                       let orderItems = item.orderItems,
                       !orderItems.isEmpty {
                            let firstName = orderItems.first?.korName ?? "-"
                            let extraCount = orderItems.count - 1
                            let displayText = extraCount > 0
                            ? "\(firstName) 외 \(extraCount)개"
                            : firstName
                            Text(displayText)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)

                    } else if item.transactionType == "CHARGE" {
                            Text("예치금 충전")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                    }
                    // 날짜
                    Text(
                        item.transactionTime != nil ? formattedDate(
                            item.transactionTime!
                        ) : "-"
                    )
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.textGray1)
                   
                    // ✅ 금액 표시 (PAY/CHARGE 구분)
                    let isPay = item.transactionType == "PAY"
                    let sign = isPay ? "-" : "+"
                    let color: Color = isPay ? .Danger : .Primary

                    Text("\(sign) \(formatPrice(item.totalAmount))")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(color)
                    
                }
                .frame(height: 60, alignment: .top)
                Spacer()
                // ✅ PAY일 때만 꺾새 표시
                 if item.transactionType == "PAY" {
                     NavigationLink(destination: ReceiptView(orderId: item.orderId ?? 1)) {
                         Image(systemName: "chevron.right")
                             .font(.system(size: 15, weight: .medium))
                             .foregroundColor(.gray)
                     }
                     .buttonStyle(.plain)
                 }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 4)
    }
}

