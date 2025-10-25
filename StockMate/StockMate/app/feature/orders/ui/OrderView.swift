//
//  OrderView.swift
//  StockMate
//
//  Created by Admin on 10/14/25.
//

import SwiftUI

struct OrderView: View {
    @StateObject private var inventoryVM = InventoryViewModel()
    @StateObject private var cartVM = CartViewModel()

    var body: some View {
        NavigationStack {
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
                    NavigationLink(destination: InventorySearchView()) {
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
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
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
                        ForEach(inventoryVM.underLimitItems) { item in
                            
                            let qty = cartVM.quantity(for: item.id)
                            
                            OrderRequestCardView(
                                item: item,
                                quantity: qty,
                                onIncrease: {
                                    Task {
                                        await cartVM.increaseQuantity(for: item.id)
                                    }
                                },
                                onDecrease: {
                                    Task {
                                        await cartVM.decreaseQuantity(for: item.id)
                                    }
                                },
                                onAddToCart: {
                                    Task {
                                        await cartVM.addToCart(partId: item.id, amount: 1)
                                    }
                                },
                                onRemoveFromCart: {
                                    Task {
                                        await cartVM.decreaseQuantity(for: item.id)
                                    }
                                }
                            )
                            .onAppear {
                                if item.id == inventoryVM.underLimitItems.last?.id {
                                    Task { await inventoryVM.loadUnderLimitList() }
                                }
                            }
                        }
                        
                        if inventoryVM.isLoading {
                            ProgressView().padding()
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    
                    
                }
                .background(Color.Light)
                .task {
                    await inventoryVM.loadUnderLimitList(reset: true)
                    await cartVM.fetchCart()
                }
                .alert(cartVM.message, isPresented: .constant(!cartVM.message.isEmpty)) {
                    Button("확인") { cartVM.message = "" }
                }
                
                // OrderView 내부 ScrollView 아래에 overlay 혹은 bottomBar
                VStack {
                    Spacer()
                    CartSummaryBar(cartVM: cartVM)
                }
                .ignoresSafeArea(edges: .bottom)

            }
        }
    }
}


#Preview {
    OrderView()
}
