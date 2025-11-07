//
//  OrderRequestCardView.swift
//  StockMate
//
//  Created by Admin on 10/20/25.
//

import SwiftUI

struct OrderRequestCardView: View {
    let item: InventoryItem
    let quantity: Int
    let onIncrease: () -> Void
    let onDecrease: () -> Void
    let onAddToCart: () -> Void
    let onRemoveFromCart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(item.categoryName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.black)

            Divider().frame(height: 0.2).background(Color.textGray2)

            HStack(alignment: .center, spacing: 12) {
                // 부품 이미지
                AsyncImage(url: URL(string: item.image)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 64, height: 64)
                .cornerRadius(10)

                // 이름 및 정보
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.korName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(2)

                    Text("\(item.trim) / \(item.model)")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)

                    Text("\(item.price)원")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                }

                Spacer()

                // 수량 컨트롤러
                // 🪄 수량에 따른 3단계 분기
                if quantity == 0 {
                    Button(action: onAddToCart) {
                        Image("add_shopping_cart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)

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

#Preview {
    let sampleItem = InventoryItem(
        id: 1,
        name: "Engine Oil Filter",
        price: 18000,
        image: "https://picsum.photos/200",
        trim: "1.6 Turbo",
        model: "SM-230",
        category: 3,
        korName: "엔진 오일 필터",
        engName: "Engine Oil Filter",
        categoryName: "엔진 부품",
        stock: 42,
        amount: 3,
        limitAmount: 5,
        isLack: true
    )

    VStack(spacing: 20) {
        // 수량 0 (아직 카트에 안 담김)
        OrderRequestCardView(
            item: sampleItem,
            quantity: 0,
            onIncrease: {},
            onDecrease: {},
            onAddToCart: {},
            onRemoveFromCart: {}
        )

        // 수량 1 (카트에 하나 있음)
        OrderRequestCardView(
            item: sampleItem,
            quantity: 1,
            onIncrease: {},
            onDecrease: {},
            onAddToCart: {},
            onRemoveFromCart: {}
        )

        // 수량 3 (여러 개 담긴 상태)
        OrderRequestCardView(
            item: sampleItem,
            quantity: 3,
            onIncrease: {},
            onDecrease: {},
            onAddToCart: {},
            onRemoveFromCart: {}
        )
    }
    .padding()
    .background(Color(uiColor: .systemGray6))
}
