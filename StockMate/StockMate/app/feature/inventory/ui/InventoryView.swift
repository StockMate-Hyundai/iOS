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
                        .padding(.horizontal,25)
                        .padding(.top)
                    
                
                    // 공통 컴포넌트 리스트
                    ScrollView{
                        VStack(spacing: 12) {
                            // 예시 데이터
                            let dummyData: [(String, String, Int, Int)] = [
                                ("브레이크", "현대 아이오닉5", 5, 10),
                                ("엔진오일", "기아 EV6", 10, 12),
                                ("에어필터", "현대 코나", 8, 10)
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
        ("입고 처리", "입고 내역", Color.InvIncoming, Color.InvIncomingBg, "InvIncoming", AnyView(IncomingScanView())),
        ("사용 처리", "사용 내역", Color.InvUse, Color.InvUseBg, "InvUse", AnyView(IncomingScanView())),
        ("이동 요청", "이동 내역", Color.Transfer, Color.TransferBg, "InvTrans", AnyView(IncomingScanView())),
        ("재고 조회", "", Color.InvStock, Color.InvStockBg, "InvStock",  AnyView(IncomingScanView()))
    ]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
            ForEach(menuItems, id: \.0) { item in
                VStack(spacing: 8) {
                    
                    Image(item.4)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(item.3)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    HStack(spacing: 8) {
                        NavigationLink(destination: item.5) {
                            Text(item.0)
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(item.2)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(item.3)
                                .cornerRadius(5)
                        }
                        
                        if !item.1.isEmpty {
                            Text(item.1)
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(item.2)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(item.3)
                                .cornerRadius(5)
                        }
                    }
                    .padding(.top,5)
                    .font(.subheadline)
                }
                .frame(maxWidth: .infinity, minHeight: 120)
                .background(RoundedRectangle(cornerRadius: 12).stroke(item.2, lineWidth: 1.5))
            }
            .padding(.horizontal,3)
        }
        .padding()
        .background(Color.White)
        .padding(.horizontal)
    }
}

struct MenuCard: View {
    let title1: String
    let title2: String
    let color: Color
    let bgColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "shippingbox")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                .padding(12)
                .background(bgColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            HStack(spacing: 8) {
                Text(title1)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(bgColor)
                    .cornerRadius(5)
                
                if !title2.isEmpty {
                    Text(title2)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(color)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(bgColor)
                        .cornerRadius(5)
                }
            }
            .padding(.top, 5)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(RoundedRectangle(cornerRadius: 12).stroke(color, lineWidth: 1.5))
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
            
            VStack(alignment: .leading){
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
