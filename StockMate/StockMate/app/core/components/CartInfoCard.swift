//
//  CartInfoCard.swift
//  StockMate
//
//  Created by Admin on 10/27/25.
//

import SwiftUI

struct CartInfoCard: View {
    let item: CartItem
    let quantity: Int

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

                    HStack{
                        Text("\((item.trim ?? "")) / \((item.model ?? ""))")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text("\((item.price ?? 0) * item.amount)원")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.black)
                            .lineLimit(1)

                    }
                    Text("\(item.price ?? 0)원 / \(item.amount)개")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
    }
}

#Preview {
    CartInfoCard(
        item: CartItem(
            cartItemId: 1,
            partId: 101,
            amount: 2,
            partName: "실린더 어셈블리 브레이크 마스터",
            categoryName: "엔진/미션",
            brand: "실린더 어셈블리 브레이크 마스터",
            model: "아반떼 MD",
            trim: "중형",
            price: 60000,
            stock: 30,
            image: ""
        ),
        quantity: 2
    )
    .previewLayout(.sizeThatFits)
    .padding()
    .background(Color.Light)
}
