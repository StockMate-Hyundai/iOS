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
    let onAddToCart: (() -> Void)?
    let onRemoveFromCart: () -> Void

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

                // 🪄 수량에 따른 3단계 분기
                if quantity == 0 {
                    if let onAddToCart = onAddToCart {
                        Button(action: onAddToCart) {
//                            Image(systemName: "cart.badge.plus")
//                            .font(.system(size: 18))
//                            .foregroundColor(.Primary)
//                            .padding(10)
//                            .background(Color.Primary.opacity(0.1))
//                            .clipShape(Circle())
                            Image("add_shopping_cart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .padding(10)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
                        }
                    }
                } else if quantity == 1 {
                    HStack(spacing: 10) {
                        Button(action: onRemoveFromCart) {
                            Image(systemName: "trash")
                                .font(.system(size: 14, weight: .regular))
                                .frame(width: 13,height: 13)
                                .foregroundColor(.black)
                        }
                        
                        Text("1")
                            .font(.system(size: 15, weight: .medium))
                            .frame(width: 20)

                        Button(action: onIncrease) {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .regular))
                                .frame(width: 13,height: 13)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(   // ✅ 테두리 추가
                        RoundedRectangle(cornerRadius: 10)
                            .stroke( Color.LightBlue03, lineWidth: 2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)

                } else {
                    HStack(spacing: 10) {
                        Button(action: onDecrease) {
                            Image(systemName: "minus")
                                .font(.system(size: 14, weight: .regular))
                                .frame(width: 13,height: 13)
                                .foregroundColor(.black)
                        }

                        Text("\(quantity)")
                            .font(.system(size: 15, weight: .medium))
                            .frame(width: 20)

                        Button(action: onIncrease) {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .regular))
                                .frame(width: 13,height: 13)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(   // ✅ 테두리 추가
                        RoundedRectangle(cornerRadius: 10)
                            .stroke( Color.LightBlue03, lineWidth: 2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 4)
    }
}
