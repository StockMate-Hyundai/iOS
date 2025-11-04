//
//  OrderView.swift
//  StockMate
//
//  Created by Admin on 10/14/25.
//

import SwiftUI

struct OrderView: View {
    @StateObject var inventoryViewModel = InventoryViewModel()
    @ObservedObject var cartViewModel: CartViewModel
    
    var body: some View {
        ZStack{
            ScrollView {
                // 타이틀
                Text("재고 관리")
                    .font(.title2)
                    .bold()
                    .padding(.top, 13)
                    .padding(.leading, 25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("직접 발주")
                    .font(.system(size: 14))
                    .bold()
                    .padding(.top, 13)
                    .padding(.leading, 25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // 🔍 검색창
                NavigationLink(destination:
                    OrderRequestSearchView(
                        cartViewModel: cartViewModel
                        //inventoryViewModel: inventoryViewModel
                    )
                ) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        Text("부품을 검색하세요.")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding()
                    .background(Color(.white))
                    .cornerRadius(9999)
                    .overlay(
                        RoundedRectangle(cornerRadius: 9999)
                            .stroke(Color.GrayMordern400, lineWidth: 1)
                    )
                    .padding(.horizontal)
                }
                .buttonStyle(.plain)
                
                // 타이틀
                Text("부족 재고")
                    .font(.system(size: 14))
                    .bold()
                    .padding(.top, 13)
                    .padding(.leading, 25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LazyVStack(alignment: .leading, spacing: 14) {
                    ForEach(inventoryViewModel.underLimitItems) { item in
                        
                        let qty = cartViewModel.quantity(for: item.id)
                        
                        OrderRequestCardView(
                            item: item,
                            quantity: qty,
                            onIncrease: {
                                Task {
                                    await cartViewModel.increaseQuantity(for: item.id)
                                }
                            },
                            onDecrease: {
                                Task {
                                    await cartViewModel.decreaseQuantity(for: item.id)
                                }
                            },
                            onAddToCart: {
                                Task {
                                    await cartViewModel.addToCart(partId: item.id, amount: 1)
                                }
                            },
                            onRemoveFromCart: {
                                Task {
                                    await cartViewModel.decreaseQuantity(for: item.id)
                                }
                            }
                        )
                        .onAppear {
                            if item.id == inventoryViewModel.underLimitItems.last?.id {
                                Task { await inventoryViewModel.loadUnderLimitList() }
                            }
                        }
                    }
                    
                    if inventoryViewModel.isLoading {
                        ProgressView().padding()
                    }
                }
                .padding(.horizontal)
                
            }
            .background(Color.Light)
            .task {
                if inventoryViewModel.underLimitItems.isEmpty {
                       await inventoryViewModel.loadUnderLimitList(reset: true)
                   }
                await cartViewModel.fetchCart()
            }
            
            // OrderView 내부 ScrollView 아래 장바구니 확인 버튼
            VStack {
                Spacer()
                CartSummaryBar(cartVM: cartViewModel)
            }
            .ignoresSafeArea(edges: .bottom)

        }

    }
}

