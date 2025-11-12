//
//  OrderCartView.swift
//  StockMate
//
//  Created by Admin on 10/20/25.
//

import SwiftUI

struct OrderCartView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var cartViewModel: CartViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            if cartViewModel.items.isEmpty {
              // 장바구니 비어있을 때
              VStack(spacing: 8) {
                  Text("장바구니가 비어있어요.")
                      .font(.system(size: 15, weight: .regular))
                      .foregroundColor(.black)
                  Text("부품을 담아보세요.")
                      .font(.system(size: 13))
                      .foregroundColor(.gray)
              }
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(Color.Light)
            } else {
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
                                }
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .background(Color.Light)
            }
            
            NavigationLink(destination: OrderInfoView(cartViewModel: cartViewModel)) {
                Text("\(cartViewModel.cart?.totalPrice ?? 0)원 결제하기")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(cartViewModel.items.isEmpty ? Color.gray.opacity(0.3) : Color.Primary)
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 30)
            }
            .disabled(cartViewModel.items.isEmpty)

            
        }
        .background(Color.Light)
        .navigationTitle("장바구니 확인")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundColor(.black)
                }
            }
        }
        .task {
            await cartViewModel.fetchCart()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

