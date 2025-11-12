//
//  CartCard.swift
//  StockMate
//
//  Created by Admin on 10/27/25.
//

import SwiftUI

struct CartCard: View {
    let item: CartItem
    let quantity: Int
    let onIncrease: () -> Void
    let onDecrease: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(item.categoryName ?? "")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.black)

            Divider().frame(height: 0.2).background(Color.textGray2)

            HStack(alignment: .center, spacing: 12) {
                AsyncImage(url: URL(string: item.image ?? "")) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 64, height: 64)
                .cornerRadius(10)

                VStack(alignment: .leading, spacing: 6) {
                    Text(item.brand ?? "")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(2)

                    Text("\((item.trim ?? "")) / \((item.model ?? ""))")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(1)

                    Text("\(item.price ?? 0)원")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)

                }

                Spacer()

                QuantityControlView(
                    quantity: quantity,
                    onIncrease: onIncrease,
                    onDecrease: onDecrease
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 4)
    }
}
