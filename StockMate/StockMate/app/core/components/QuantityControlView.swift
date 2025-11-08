//
//  QuantityControlView.swift
//  StockMate
//
//  Created by Admin on 11/8/25.
//

import SwiftUI

struct QuantityControlView: View {
    let quantity: Int
    let onIncrease: () -> Void
    let onDecrease: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            // 감소 버튼
            Button(action: onDecrease) {
                Image(systemName: "minus")
                    .font(.system(size: 14, weight: .regular))
                    .frame(width: 13, height: 13)
                    .foregroundColor(.black)
            }
            
            // 수량 표시
            Text("\(quantity)")
                .font(.system(size: 15, weight: .medium))
                .frame(width: 20)
                .animation(.easeInOut(duration: 0.2), value: quantity)
            
            // 증가 버튼
            Button(action: onIncrease) {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .regular))
                    .frame(width: 13, height: 13)
                    .foregroundColor(.black)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke( Color.LightBlue03, lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
    }
}

#Preview {
    QuantityControlView(
        quantity: 2,
        onIncrease: { print("➕ 수량 증가") },
        onDecrease: { print("➖ 수량 감소") }
    )
    .padding()
    .background(Color.Light)
}
