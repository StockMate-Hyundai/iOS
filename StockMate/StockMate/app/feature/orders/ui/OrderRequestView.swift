//
//  OrderRequestView.swift
//  StockMate
//
//  Created by Admin on 10/20/25.
//

import SwiftUI

struct OrderRequestView: View {
//    @StateObject private var inventoryViewModel = InventoryViewModel()
//    @State private var showScrollToTopButton = false
//    @Namespace private var topID
//
//    @State private var cartItems: [InventoryItem: Int] = [:] // [품목: 수량]
//       
//    var totalPrice: Int {
//        cartItems.reduce(0) { $0 + ($1.key.price * $1.value) }
//    }

    var body: some View {
//        NavigationStack {
//            ScrollViewReader { proxy in
//                ZStack {
//                    ScrollView {
//                        VStack(spacing: 0) {
//                            GeometryReader { geo in
//                                Color.clear
//                                    .onChange(of: geo.frame(in: .global).minY) { newValue in
//                                        withAnimation(.easeInOut(duration: 0.25)) {
//                                            showScrollToTopButton = newValue < -150
//                                        }
//                                    }
//                            }
//                            .frame(height: 0)
//                            .id(topID)
//
//                            // 상단 타이틀
//                            HStack {
//                                Text("발주 요청")
//                                    .font(.title3)
//                                    .bold()
//                                Spacer()
//                                Image(systemName: "cart")
//                                    .font(.system(size: 20))
//                                    .foregroundColor(.black)
//                            }
//                            .padding(.horizontal, 25)
//                            .padding(.top, 10)
//
//                            // 검색창
//                            HStack {
//                                Image(systemName: "magnifyingglass")
//                                    .foregroundColor(.gray)
//                                TextField("부품을 검색하세요.", text: .constant(""))
//                            }
//                            .padding(.horizontal)
//                            .padding(.vertical, 12)
//                            .background(
//                                RoundedRectangle(cornerRadius: 14)
//                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                            )
//                            .padding(.horizontal, 20)
//                            .padding(.top, 10)
//
//                            // 부족 재고 리스트
//                            VStack(alignment: .leading, spacing: 12) {
//                                Text("부족 재고")
//                                    .font(.system(size: 18, weight: .semibold))
//                                    .foregroundColor(.black)
//                                    .padding(.horizontal, 25)
//                                    .padding(.top, 15)
//
//                                LazyVStack(spacing: 14) {
//                                    ForEach(inventoryViewModel.underLimitItems) { item in
//                                        OrderRequestCardView(
//                                            item: item,
//                                            quantity: cartItems[item] ?? 0,
//                                            onAdd: {
//                                                cartItems[item, default: 0] += 1
//                                            },
//                                            onRemove: {
//                                                if let current = cartItems[item], current > 0 {
//                                                    cartItems[item] = current - 1
//                                                }
//                                            },
//                                            onCartAdd: {
//                                                cartItems[item, default: 0] += 1
//                                            }
//                                        )
//                                        .padding(.horizontal, 20)
//                                        .onAppear {
//                                            if item.id == inventoryViewModel.underLimitItems.last?.id {
//                                                Task {
//                                                    await inventoryViewModel.loadUnderLimitList()
//                                                }
//                                            }
//                                        }
//                                    }
//
//                                    if inventoryViewModel.isLoading {
//                                        ProgressView().padding(.vertical, 20)
//                                    }
//                                }
//                                .padding(.bottom, 100)
//                            }
//                        }
//                    }
//
//                    // ✅ 하단 장바구니 버튼
//                    VStack {
//                        Spacer()
//                        NavigationLink(destination: OrderCartView()) {
//                            HStack {
//                                Circle()
//                                    .fill(Color.white)
//                                    .frame(width: 20, height: 20)
//                                    .overlay(
//                                        Text("\(cartItems.count)")
//                                            .font(.system(size: 11, weight: .bold))
//                                            .foregroundColor(.Primary)
//                                    )
//
//                                Text("장바구니 보기")
//                                    .font(.system(size: 16, weight: .bold))
//                                    .foregroundColor(.white)
//
//                                Spacer()
//
//                                Text("\(totalPrice)원")
//                                    .font(.system(size: 16, weight: .semibold))
//                                    .foregroundColor(.white)
//                            }
//                            .padding(.horizontal, 30)
//                            .frame(height: 60)
//                            .background(Color.Primary)
//                            // 위쪽 두 모서리만 둥글게
//                            .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
//                        }
//                    }
//                }
//                .background(Color.Light)
//                .edgesIgnoringSafeArea(.bottom) // 탭에 딱 맞닿게
//                .task {
//                    await inventoryViewModel.loadUnderLimitList(reset: true)
//                }
//            }
//        }
    }
}

//// ✅ 특정 코너만 둥글게 처리할 수 있게 하는 Shape
//struct RoundedCorner: Shape {
//    var radius: CGFloat = 16
//    var corners: UIRectCorner = .allCorners
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(
//            roundedRect: rect,
//            byRoundingCorners: corners,
//            cornerRadii: CGSize(width: radius, height: radius)
//        )
//        return Path(path.cgPath)
//    }
//}

#Preview {
    OrderRequestView()
}
