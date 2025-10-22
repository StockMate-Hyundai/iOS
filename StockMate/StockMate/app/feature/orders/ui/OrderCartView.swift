//
//  OrderCartView.swift
//  StockMate
//
//  Created by Admin on 10/20/25.
//

import SwiftUI

struct OrderCartView: View {
//    
//    @State private var cartItems: [InventoryItem: Int] = [
//        InventoryItem(
//            id: 1,
//            korName: "아반떼MD",
//            model: "실린더 어셈블리-브레이크 마스터",
//            trim: "엔진/미션",
//            price: 3000,
//            image: "https://via.placeholder.com/100",
//            categoryName: "엔진/미션"
//        ): 1,
//        InventoryItem(
//            id: 2,
//            korName: "소나타DN8",
//            model: "브레이크 오일 탱크",
//            trim: "엔진/미션",
//            price: 5000,
//            image: "https://via.placeholder.com/100",
//            categoryName: "엔진/미션"
//        ): 2
//    ]
//
//    var totalPrice: Int {
//        cartItems.reduce(0) { $0 + ($1.key.price * $1.value) }
//    }
//    
    var body: some View {
//        NavigationStack {
//            ZStack {
//                ScrollView {
//                    VStack(spacing: 14) {
//                        ForEach(Array(cartItems.keys), id: \.id) { item in
//                            if let quantity = cartItems[item] {
//                                HStack(alignment: .center, spacing: 12) {
//                                    AsyncImage(url: URL(string: item.image)) { image in
//                                        image.resizable().scaledToFit()
//                                    } placeholder: {
//                                        Color.gray.opacity(0.2)
//                                    }
//                                    .frame(width: 64, height: 64)
//                                    .cornerRadius(10)
//                                    
//                                    VStack(alignment: .leading, spacing: 6) {
//                                        Text(item.korName)
//                                            .font(.system(size: 14, weight: .bold))
//                                            .foregroundColor(.black)
//                                            .lineLimit(2)
//                                        
//                                        Text(item.model)
//                                            .font(.system(size: 13))
//                                            .foregroundColor(.gray)
//                                        
//                                        Text("\(item.price)원")
//                                            .font(.system(size: 13, weight: .semibold))
//                                            .foregroundColor(.black)
//                                    }
//                                    
//                                    Spacer()
//                                    
//                                    HStack(spacing: 10) {
//                                        Button {
//                                            if quantity > 1 {
//                                                cartItems[item] = quantity - 1
//                                            } else {
//                                                cartItems.removeValue(forKey: item)
//                                            }
//                                        } label: {
//                                            Image(systemName: quantity > 1 ? "minus" : "trash")
//                                                .font(.system(size: 14, weight: .bold))
//                                                .foregroundColor(quantity > 1 ? .gray : .red)
//                                        }
//                                        
//                                        Text("\(quantity)")
//                                            .font(.system(size: 15, weight: .semibold))
//                                            .frame(width: 24)
//                                        
//                                        Button {
//                                            cartItems[item] = quantity + 1
//                                        } label: {
//                                            Image(systemName: "plus")
//                                                .font(.system(size: 14, weight: .bold))
//                                                .foregroundColor(.Primary)
//                                        }
//                                    }
//                                    .padding(.vertical, 6)
//                                    .padding(.horizontal, 10)
//                                    .background(Color.white)
//                                    .cornerRadius(10)
//                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 4)
//                                }
//                                .padding()
//                                .background(Color.white)
//                                .cornerRadius(14)
//                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 4)
//                                .padding(.horizontal, 20)
//                            }
//                        }
//                        Spacer(minLength: 100)
//                    }
//                    .padding(.top, 10)
//                }
//                
//                // 하단 결제 버튼
//                VStack {
//                    Spacer()
//                    Button {
//                        // 결제 액션
//                    } label: {
//                        Text("\(totalPrice)원 결제하기")
//                            .font(.system(size: 16, weight: .bold))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 60)
//                            .background(Color.Primary)
//                    }
//                }
//            }
//            .background(Color.Light)
//            .navigationTitle("장바구니 확인")
//            .navigationBarTitleDisplayMode(.inline)
//            .edgesIgnoringSafeArea(.bottom)
//        }
    }
}

#Preview {
//    OrderCartView()
}
