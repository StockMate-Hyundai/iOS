//
//  BottomToast.swift
//  StockMate
//
//  Created by Admin on 11/10/25.
//

import SwiftUI

// 화면 하단에 토스트 알림 뷰
struct BottomToast: View {
    let message: String
    @Binding var isVisible: Bool
    var iconName: String = "toastlogo"
    var iconColor: Color = .white
    var backgroundColor: Color = Color(hex: "4CAF50")
    var duration: Double = 2.2

    var body: some View {
        VStack {
            Spacer()
            
            // 토스트가 표시될 때만 렌더링
            if isVisible {
                HStack(spacing: 10) {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)

                    Text(message)
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 9999)
                        .fill(backgroundColor)
                )
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
                .padding(.bottom, 60)
                .padding(.horizontal, 50)
                .onAppear {                         // 토스트가 나타날 때 타이머 시작
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isVisible = false
                        }
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isVisible)
    }
}
