//
//  OrderCartView.swift
//  StockMate
//
//  Created by Admin on 10/20/25.
//

import SwiftUI

struct OrderCartView: View {
    @ObservedObject var cartViewModel: CartViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(cartViewModel.items) { cartItem in
                        
                        CartCard(
                            item: cartItem,
                            quantity: cartItem.amount,
                            onIncrease: {
                                Task { await cartViewModel.increaseQuantity(for: cartItem.partId) }
                            },
                            onDecrease: {
                                Task { await cartViewModel.decreaseQuantity(for: cartItem.partId) }
                            },
                            onAddToCart: nil,
                            onRemoveFromCart: {
                                Task {
                                    await cartViewModel.decreaseQuantity(for: cartItem.partId)
                                }
                            }
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color.Light)
            
            
            NavigationLink(destination: OrderInfoView(cartViewModel: cartViewModel)) {
                Text("\(cartViewModel.cart?.totalPrice ?? 0)원 결제하기")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.Primary)
            }
            
        }
        .background(Color.Light)
        .navigationTitle("장바구니 확인")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await cartViewModel.fetchCart()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

