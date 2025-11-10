//
//  ToastModifier.swift
//  StockMate
//
//  Created by Admin on 11/9/25.
//

import SwiftUI

struct ToastView: View {
    let message: String
    let iconName: String?      // 아이콘 이름 (예: "checkmark.circle.fill" or "xmark.circle.fill")
    let iconColor: Color?      // 아이콘 색상 (예: .green, .red 등)

    var body: some View {
        ZStack {
           // 메시지 중앙 정렬
           Text(message)
               .font(.system(size: 14, weight: .medium))
               .foregroundColor(.white)
               .multilineTextAlignment(.center)
               .frame(maxWidth: .infinity)
               .padding(.horizontal, 40) // 아이콘 영역 고려해서 여백 확보

           // 아이콘 왼쪽 고정
           if let iconName, let iconColor {
               HStack {
                   Image(systemName: iconName)
                       .foregroundColor(iconColor)
                       .font(.system(size: 18))
                   Spacer()
               }
               .padding(.leading, 16)
           }
       }
       .padding(.vertical, 14)
       .frame(maxWidth: .infinity)
       .background(Color.black.opacity(0.75))
       .cornerRadius(9999)
       .padding(.horizontal, 24)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let iconName: String?
    let iconColor: Color?
    let duration: Double

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                VStack {
                    Spacer()
                    ToastView(message: message, iconName: iconName, iconColor: iconColor)
                        .transition(.opacity.combined(with: .scale))
                        .padding(.bottom, 60)
                }
                .animation(.easeInOut(duration: 0.35), value: isPresented)
            }
        }
        .onChange(of: isPresented) { shown in
            if shown {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    withAnimation(.easeOut(duration: 0.4)) {
                        isPresented = false
                    }
                }
            }
        }
    }
}

extension View {
    func toast(
        isPresented: Binding<Bool>,
        message: String,
        iconName: String? = nil,
        iconColor: Color? = nil,
        duration: Double = 2.0
    ) -> some View {
        self.modifier(
            ToastModifier(
                isPresented: isPresented,
                message: message,
                iconName: iconName,
                iconColor: iconColor,
                duration: duration
            )
        )
    }
}
