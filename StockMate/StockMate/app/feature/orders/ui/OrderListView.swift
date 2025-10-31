//
//  OrderListView.swift
//  StockMate
//
//  Created by Admin on 10/21/25.
//

import SwiftUI

struct OrderListView: View {
    @StateObject private var orderViewModel = OrderViewModel()

    var body: some View {
//        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                
                if orderViewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = orderViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if orderViewModel.orders.isEmpty {
                    Text("주문 내역이 없습니다.")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // 날짜별로 그룹화 (최신순)
//                    let groupedOrders = Dictionary(grouping: orderViewModel.orders) { order in
//                        order.createdAt.split(separator: "T").first ?? ""
//                    }
                    let groupedOrders = Dictionary(grouping: orderViewModel.orders) { order in
                        order.createdAt.split(separator: "T").first.map(String.init) ?? ""
                    }
                    .sorted { $0.key > $1.key }

                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 20) {
                            ForEach(groupedOrders, id: \.key) { date, orders in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(formatDate(String(date)))
                                        .font(.headline)
                                        .padding(.leading, 25)
                                        .padding(.top)

                                    ForEach(orders) { order in
                                        OrderListCardView(order: order, orderViewModel: orderViewModel)
                                    }
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                    .padding(.top)
                }
            }
            .background(Color.Light)
            .navigationTitle("주문 내역")
            .task {
                await orderViewModel.loadOrders()
            }
//        }
    }

    func formatDate(_ dateString: String) -> String {
        // yyyy-MM-dd → yyyy / MM / dd
        let comps = dateString.split(separator: "-")
        guard comps.count == 3 else { return dateString }
        return "\(comps[0])년 \(comps[1])월 \(comps[2])일"
    }
}

struct OrderListCardView: View {
    let order: OrderResponseItem
    @ObservedObject var orderViewModel: OrderViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            // 상단: 주문번호 + 상세 버튼
            HStack {
                Text("주문 번호: \(order.orderNumber)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                NavigationLink(destination: OrderDetailView(orderId: order.id, orderViewModel: orderViewModel)) {
                    Text("주문 상세 >")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Divider()

            HStack(alignment: .center, spacing: 12) {
                // 대표 이미지
                AsyncImage(url: URL(string: order.orderItems.first?.partDetail.image ?? "")) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 64, height: 64)
                .cornerRadius(10)

                // 제품명 + 개수
                VStack(alignment: .leading, spacing: 4) {
                    if let first = order.orderItems.first {
                        Text(first.partDetail.korName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .lineLimit(1)

                        if order.orderItems.count > 1 {
                            Text("외 \(order.orderItems.count - 1)개")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }

                Spacer()

                // 상태 뱃지
                Text(statusText(order.orderStatus))
                    .font(.system(size: 13, weight: .semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(statusBdColor(order.orderStatus))
                    .foregroundColor(statusColor(order.orderStatus))
                    .cornerRadius(15)
            }

            // 주문취소 버튼 (필요 시)
            if order.orderStatus == "ORDER_COMPLETED" {
                Button(action: {
                    // 주문취소 처리
                    Task {
                        await orderViewModel.cancelOrder(orderId: order.id)
                    }
                }) {
                    Text("주문 취소")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.Primary)
                        .cornerRadius(6)
                }
                .padding(.top, 6)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}
