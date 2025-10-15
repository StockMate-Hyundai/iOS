//
//  OrderView.swift
//  StockMate
//
//  Created by Admin on 10/14/25.
//

import SwiftUI

struct OrderView: View {
    var body: some View {
        VStack(spacing: 0) {
            // 상단 타이틀
            Text("발주 목록")
                .font(.headline)
                .padding(.top, 16)
            
            // 필터 탭 버튼
//            HStack(spacing: 10) {
//                ForEach(["Product", "Category", "Payment", "status"], id: \.self) { title in
//                    Text(title)
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(.black.opacity(0.8))
//                        .padding(.horizontal, 14)
//                        .padding(.vertical, 8)
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
//                }
//            }
//            .padding(.top, 12)
            
            // 주문 리스트
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    OrderSection(date: "2025/09/30", orders: [
                        OrderItem(image: "bolt.fill", name: "현대 아이오닉5", detail: "브레이크 등/ 5개", price: "₩300,000", status: "배송중", color: .green),
                        OrderItem(image: "bolt.fill", name: "현대 아이오닉5", detail: "브레이크 등/ 5개", price: "₩300,000", status: "승인완료", color: .green),
                        OrderItem(image: "bolt.fill", name: "현대 아이오닉5", detail: "브레이크 등/ 5개", price: "₩300,000", status: "승인완료", color: .green),
                        OrderItem(image: "bolt.fill", name: "현대 아이오닉5", detail: "브레이크 등/ 5개", price: "₩300,000", status: "승인 대기", color: .orange)
                    ])
                    
                    OrderSection(date: "2025/09/29", orders: [
                        OrderItem(image: "bolt.fill", name: "현대 아이오닉5", detail: "브레이크 등/ 5개", price: "₩300,000", status: "승인 거절", color: .red),
                        OrderItem(image: "bolt.fill", name: "현대 아이오닉5", detail: "브레이크 등/ 5개", price: "₩300,000", status: "입고완료", color: .blue)
                    ])
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            
            // 하단 고정 버튼
            Button(action: {
                // 발주 요청 액션
            }) {
                Text("발주 요청")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(#colorLiteral(red: 0.215, green: 0.318, blue: 0.686, alpha: 1))) // #374EAF
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
            }
        }
        .background(Color(.systemGray6))
        .ignoresSafeArea(edges: .bottom)
    }
}

struct OrderSection: View {
    var date: String
    var orders: [OrderItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(date)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
            
            ForEach(orders, id: \.id) { order in
                HStack {
                    Image(systemName: order.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(6)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.05), radius: 2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(order.name)
                            .font(.system(size: 15, weight: .semibold))
                        Text(order.detail)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 6) {
                        Text(order.price)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.purple)
                        Text(order.status)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(order.color)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(order.color.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.03), radius: 2)
            }
        }
    }
}

struct OrderItem: Identifiable {
    let id = UUID()
    var image: String
    var name: String
    var detail: String
    var price: String
    var status: String
    var color: Color
}

#Preview {
    OrderView()
}
