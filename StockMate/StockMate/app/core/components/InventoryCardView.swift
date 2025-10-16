//
//  InventoryCardView.swift
//  StockMate
//
//  Created by Admin on 10/16/25.
//

import SwiftUI


struct InventoryCardView: View {
    let item: InventoryItem
    var showStatus: Bool = true // 필요 시 상태 표시 숨기기 옵션

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // 상단 카테고리
            Text(item.categoryName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.black)
            
            Divider()
                .frame(height: 0.2)
                .background(Color.textGray2)
            
            HStack(alignment: .center, spacing: 12) {
                // 제품 이미지
                AsyncImage(url: URL(string: item.image)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 64, height: 64)
                .cornerRadius(10)
                
                // 제품명, 트림/모델
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(item.korName)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                            .lineLimit(2)
                        Spacer()
                    }
                    .padding(.top, 2)
                    
                    Text("\(item.trim) / \(item.model)")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.gray)
                }
                .frame(height: 60, alignment: .top)

                // 상태 표시 (옵션)
                if showStatus {
                    VStack(alignment: .center, spacing: 6) {
                        if item.isLack {
                            Text("수량 부족")
                                .font(.system(size: 13, weight: .regular))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.DangerBg)
                                .foregroundColor(.Danger)
                                .cornerRadius(12)
                        } else {
                            Text("수량 여유")
                                .font(.system(size: 13, weight: .regular))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.StatusGreenBg)
                                .foregroundColor(.StatusGreen)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("현재수량: \(item.amount)개")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.textGray1)
                            Text("최소수량: \(item.limitAmount)개")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.textGray1)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 4)
    }
}
