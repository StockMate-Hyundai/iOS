//
//  InventoryView.swift
//  StockMate
//
//  Created by Admin on 10/12/25.
//

import SwiftUI

struct InventoryView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 13) {
                Text("재고 관리")
                    .font(.title2)
                    .bold()
                    .padding(.top, 13)
                    .frame(maxWidth: .infinity, alignment: .center)

                // 4개 버튼 영역
                GridMenuView()

                // 섹션 타이틀
                Text("얼마 남지 않았어요!")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 25)
                    .padding(.top)

                // 공통 컴포넌트 리스트
                ScrollView {
                    VStack(spacing: 12) {
                        // 예시 데이터
                        let dummyData: [(String, String, Int, Int)] = [
                            ("브레이크", "현대 아이오닉5", 5, 10),
                            ("엔진오일", "기아 EV6", 10, 12),
                            ("에어필터", "현대 코나", 8, 10),
                        ]

                        ForEach(dummyData, id: \.0) { item in
                            StockShortageCard(
                                partName: item.0,
                                carModel: item.1,
                                currentCount: item.2,
                                minCount: item.3
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.Light)
        }
    }
}

struct GridMenuView: View {
    let menuItems = [
        ("재고조회", Color.InvIncoming, Color.InvIncomingBg, AnyView(IncomingScanView())),
        ("입출고 히스토리", Color.InvUse, Color.InvUseBg, AnyView(IncomingScanView())),
        ("입고처리", Color.Transfer, Color.TransferBg, AnyView(IncomingScanView())),
        ("사용처리", Color.InvStock, Color.InvStockBg, AnyView(IncomingScanView())),
    ]

    var body: some View {
        VStack(spacing: 20) {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 15),
                    GridItem(.flexible(), spacing: 15),
                ],
                spacing: 15
            ) {

                ForEach(menuItems, id: \.0) { item in
                    ZStack {
                        // 그림자 전용 레이어 (NavigationLink 뒤에 위치)
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(
                                color: .black.opacity(0.25),
                                radius: 4,
                                x: 0,
                                y: 4
                            )

                        // 버튼 본체
                        NavigationLink(destination: item.3) {
                            VStack(spacing: 12) {
                                Image("InvStock")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(item.1)
                                    .padding(.top, 20)

                                Text(item.0)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(item.1)
                                    .padding(.bottom, 20)
                            }
                            .frame(maxWidth: .infinity, minHeight: 120)
                            .background(item.2.opacity(0.5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(item.1, lineWidth: 1.2)
                            )
                            .cornerRadius(16)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.horizontal, 10)
        }
        .padding()
        .background(Color.White)
        .padding(.horizontal)
    }
}

struct StockShortageCard: View {
    let partName: String
    let carModel: String
    let currentCount: Int
    let minCount: Int

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 68, height: 68)

            VStack(alignment: .leading, spacing: 4) {
                Text(partName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(carModel)
                    .font(.subheadline)
                    .foregroundColor(.textGray1)
            }
            Spacer()

            VStack(alignment: .leading) {
                Text("수량 부족")
                    .font(.system(size: 14, weight: .semibold))
                    .fontWeight(.regular)
                    .foregroundColor(.StatusRed)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.StatusRedBg)
                    .cornerRadius(14)

                Text("현재수량: \(currentCount)개")
                    .font(.caption)
                    .foregroundColor(.textGray1)

                Text("최소수량: \(minCount)개")
                    .font(.caption)
                    .foregroundColor(.textGray1)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    InventoryView()
}
