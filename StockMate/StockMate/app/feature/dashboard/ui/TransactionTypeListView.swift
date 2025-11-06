////
////  TransactionTypeListView.swift
////  StockMate
////
////  Created by Admin on 11/6/25.
////
//
//import SwiftUI
//
//struct TransactionTypeListView: View {
//    @StateObject private var viewModel = HistoryViewModel()
//
//    var body: some View {
//        NavigationView {
//            List(viewModel.transactions, id: \.id) { item in
//                HStack {
//                    // 대표 이미지
//                    AsyncImage(url: URL(string: item.orderItems?.first?.image ?? "")) { image in
//                        image.resizable().scaledToFit()
//                    } placeholder: {
//                        Image("exchange")
//                            .foregroundColor(Color.Primary)
//                    }
//                    .frame(width: 64, height: 64)
//                    .cornerRadius(10)
//                    
//
//                    VStack (alignment: .leading, spacing: 3){
//                        
//                        // ✅ PAY/CHARGE 별 상세 표시 (부품 이름/ 예치금 충전)
//                        if item.transactionType == "PAY",
//                           let orderItems = item.orderItems,
//                           !orderItems.isEmpty {
//                            NavigationLink(destination: ReceiptView(orderId: item.orderId ?? 1)) {
//                                let firstName = orderItems.first?.korName ?? "-"
//                                let extraCount = orderItems.count - 1
//                                let displayText = extraCount > 0
//                                    ? "\(firstName) 외 \(extraCount)개"
//                                    : firstName
//
//                                VStack(alignment: .leading){
//                                    Text(displayText)
//                                        .font(.subheadline)
//                                        .foregroundColor(.primary)
//                                    
//                                    // ✅ 거래 시간 (포맷 적용)
//                                    if let time = item.transactionTime {
//                                        Text(formattedDate(time))
//                                            .font(.subheadline)
//                                            .foregroundColor(.gray)
//                                    } else {
//                                        Text("-")
//                                            .font(.subheadline)
//                                            .foregroundColor(.gray)
//                                    }
//            
//                                    Text("- \(formatPrice(item.totalAmount))")
//                                        .font(.headline)
//                                        .foregroundColor(.Danger)
//                                        .frame(alignment: .trailing)
//                                }
//                            }
//                            
//                        } else if item.transactionType == "CHARGE" {
//                            Text("예치금 충전")
//                                .font(.subheadline)
//                                .foregroundColor(.blue)
//                            
//                            // ✅ 거래 시간 (포맷 적용)
//                            if let time = item.transactionTime {
//                                Text(formattedDate(time))
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                            } else {
//                                Text("-")
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                            }
//                            
//                            Text("+ \(formatPrice(item.totalAmount))")
//                                .font(.headline)
//                                .foregroundColor(.Primary)
//                                .frame(alignment: .trailing)
//                        }
//
//                    }
//                    
//                }
//                .padding(.vertical, 4)
//                .task {
//                    // ✅ 스크롤 시 끝 근처에서 다음 페이지 로드
//                    await viewModel.loadMoreTransactionsIfNeeded(currentItem: item)
//                }
//            }
//            .background(Color.Light)
//            .navigationTitle("예치금 히스토리")
//            .navigationBarTitleDisplayMode(.inline)
//            .overlay {
//                if viewModel.isTransactionLoading && viewModel.transactions.isEmpty {
//                    ProgressView("불러오는 중...")
//                }
//            }
//            .task {
//                if viewModel.transactions.isEmpty {
//                    await viewModel.fetchPaymentTransactions()
//                }
//            }
//        }
//        .background(Color.Light)
//    }
//}
//
////#Preview {
////    TransactionTypeListView()
////}
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
            HStack(alignment: .top, spacing: 12) {
                // 대표 이미지
                AsyncImage(
                    url: URL(string: item.orderItems?.first?.image ?? "")
                ) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Image("exchange")
                        .foregroundColor(Color.Primary)
                }
                .frame(width: 64, height: 64)
                .cornerRadius(10)

                VStack(alignment: .leading, spacing: 4) {
                    if item.transactionType == "PAY",
                       let orderItems = item.orderItems,
                       !orderItems.isEmpty {

                        NavigationLink(
                            destination: ReceiptView(orderId: item.orderId ?? 1)
                        ) {
                            let firstName = orderItems.first?.korName ?? "-"
                            let extraCount = orderItems.count - 1
                            let displayText = extraCount > 0
                            ? "\(firstName) 외 \(extraCount)개"
                            : firstName

                            VStack(alignment: .leading, spacing: 4) {
                                Text(displayText)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)

                                Text(
                                    item.transactionTime != nil ? formattedDate(
                                        item.transactionTime!
                                    ) : "-"
                                )
                                .font(.caption)
                                .foregroundColor(.gray)

                                Text("- \(formatPrice(item.totalAmount))")
                                    .font(.headline)
                                    .foregroundColor(.Danger)
                            }
                        }
                        .buttonStyle(.plain)

                    } else if item.transactionType == "CHARGE" {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("예치금 충전")
                                .font(.subheadline)
                                .foregroundColor(.blue)

                            Text(
                                item.transactionTime != nil ? formattedDate(
                                    item.transactionTime!
                                ) : "-"
                            )
                            .font(.caption)
                            .foregroundColor(.gray)

                            Text("+ \(formatPrice(item.totalAmount))")
                                .font(.headline)
                                .foregroundColor(.Primary)
                        }
                    }
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

