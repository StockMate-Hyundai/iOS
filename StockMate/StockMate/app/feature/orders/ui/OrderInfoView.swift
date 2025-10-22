//
//  OrderInfoView.swift
//  StockMate
//
//  Created by Admin on 10/20/25.
//

import SwiftUI
//
//struct OrderItem: Identifiable {
//    let id = UUID()
//    let name: String
//    let description: String
//    let price: Int
//    let quantity: Int
//    let imageName: String
//}

struct OrderInfoView: View {
//    @State private var orderItems: [OrderItem] = [
//        OrderItem(name: "아반떼MD", description: "실린더 어셈블리·브레이크 마스터", price: 30000, quantity: 2, imageName: "carpart"),
//        OrderItem(name: "아반떼MD", description: "실린더 어셈블리·브레이크 마스터", price: 30000, quantity: 2, imageName: "carpart")
//    ]
//    
//    @State private var selectedPayment: String = "법인 카드"
//    @State private var requestMessage: String = ""
//    @State private var showResult = false
//    
//    private var totalPrice: Int {
//        orderItems.reduce(0) { $0 + $1.price * $1.quantity }
//    }
    
    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 20) {
//                    
//                    // 배송 정보
//                    Section {
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("배송 정보")
//                                .font(.headline)
//                            Text("홍길동")
//                            Text("서울특별시 강남구 테헤란로114길")
//                            Text("010-1111-2222")
//                                .foregroundColor(.gray)
//                                .font(.subheadline)
//                            TextField("요청사항을 입력하세요", text: $requestMessage, axis: .vertical)
//                                .padding(10)
//                                .frame(height: 70)
//                                .background(Color(.systemGray6))
//                                .cornerRadius(10)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(16)
//                        .shadow(color: .black.opacity(0.05), radius: 3)
//                    }
//                    
//                    // 주문 목록
//                    Section {
//                        VStack(alignment: .leading, spacing: 12) {
//                            Text("주문 목록 (\(orderItems.count))")
//                                .font(.headline)
//                            ForEach(orderItems) { item in
//                                HStack(alignment: .top, spacing: 12) {
//                                    Image(systemName: "cube.box.fill")
//                                        .resizable()
//                                        .frame(width: 50, height: 50)
//                                        .foregroundColor(.gray)
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text(item.name)
//                                            .font(.subheadline)
//                                            .bold()
//                                        Text(item.description)
//                                            .font(.caption)
//                                            .foregroundColor(.gray)
//                                        Text("\(item.price * item.quantity)원")
//                                            .font(.subheadline)
//                                            .bold()
//                                            .frame(maxWidth: .infinity, alignment: .trailing)
//                                    }
//                                }
//                                Divider()
//                            }
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(16)
//                        .shadow(color: .black.opacity(0.05), radius: 3)
//                    }
//                    
//                    // 결제 수단
//                    Section {
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("결제 수단")
//                                .font(.headline)
//                            RadioButtonGroup(items: ["법인 카드(잔액 ₩1,200,000)", "본사 계좌이체"], selected: $selectedPayment)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(16)
//                        .shadow(color: .black.opacity(0.05), radius: 3)
//                    }
//                    
//                    // 결제 금액
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Text("결제 금액")
//                                .font(.headline)
//                            Spacer()
//                            Text("\(totalPrice)원")
//                                .font(.headline)
//                                .foregroundColor(.blue)
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//                .padding()
//            }
//            .background(Color(.systemGray6))
//            .navigationTitle("발주 요청")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: { /* 뒤로가기 동작 */ }) {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.black)
//                    }
//                }
//            }
//            .safeAreaInset(edge: .bottom) {
//                Button {
//                    // 결제 API 연동 전용 더미 로직
//                    withAnimation {
//                        showResult = true
//                    }
//                } label: {
//                    Text("결제하기")
//                        .font(.headline)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .cornerRadius(12)
//                        .padding([.horizontal, .bottom])
//                }
//            }
//            .navigationDestination(isPresented: $showResult) {
//                OrderResultView()
//            }
//        }
    }
}

//struct RadioButtonGroup: View {
//    let items: [String]
//    @Binding var selected: String
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            ForEach(items, id: \.self) { item in
//                HStack {
//                    Image(systemName: selected == item ? "circle.inset.filled" : "circle")
//                        .foregroundColor(selected == item ? .blue : .gray)
//                        .onTapGesture { selected = item }
//                    Text(item)
//                }
//            }
//        }
//    }
//}

#Preview {
    OrderInfoView()
}
