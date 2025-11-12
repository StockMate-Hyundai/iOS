//
//  TopToast.swift
//  StockMate
//
//  Created by Admin on 10/10/25.
//

import SwiftUI

struct TopToast: View {
    let message: String
    @Binding var isVisible: Bool
    var iconName: String = "exclamationmark.triangle.fill" // 기본 아이콘
    var iconColor: Color = .Danger
    var duration: Double = 2.2

    var body: some View {
        VStack(spacing: 0) {
            if isVisible {
                ZStack {
                    // 메시지 중앙 정렬
                    Text(message)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "AB3029"))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 40) // 아이콘 여백 확보

                    // 왼쪽 아이콘
                    HStack {
                        Image(systemName: iconName)
                            .foregroundColor(iconColor)
                            .font(.system(size: 18))
                        Spacer()
                    }
                    .padding(.leading, 16)
                }
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(Color.DangerBg.opacity(0.85))
                .cornerRadius(12)
                .padding(.horizontal, 24)
                .padding(.top, 14)
                .transition(.move(edge: .top).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isVisible = false
                        }
                    }
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.3), value: isVisible)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 4)
    }
}
