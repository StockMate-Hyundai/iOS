//
//  CartSummaryBar.swift
//  StockMate
//
//  Created by Admin on 10/26/25.
//

import Foundation
import SwiftUI

struct CartSummaryBar: View {
    @ObservedObject var cartVM: CartViewModel

    var body: some View {
        VStack {
            Spacer()

            if let cart = cartVM.cart,
               !cart.items.isEmpty {
                NavigationLink(destination: OrderCartView(cartViewModel: cartVM)) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Text("\(cart.items.count)")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.Primary)
                            )

                        Text("장바구니 보기")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)

                        Spacer()

                        Text("\(cart.totalPrice ?? 0)원")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 30)
                    .frame(height: 60)
                    .background(Color.Primary)
                    .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
