//
//  BottomToast.swift
//  StockMate
//
//  Created by Admin on 11/10/25.
//

//import SwiftUI
//
//struct BottomToast: View {
//    let message: String
//    @Binding var isVisible: Bool
//    var iconName: String = "toastlogo"
//    var backgroundColor: Color = Color(hex: "4CAF50") // 초록색 계열
//    var duration: Double = 2.3
//
//    var body: some View {
//        VStack {
//            Spacer()
//            
//            if isVisible {
//                HStack(spacing: 10) {
//                    Image(iconName)
//                        .resizable()
//                        .scaledToFit()
//                        .foregroundColor(.white)
//                        .font(.system(size: 18, weight: .semibold))
//                    
//                    Text(message)
//                        .font(.system(size: 14, weight: .semibold))
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .lineLimit(2)
//                }
//                .padding(.horizontal, 18)
//                .padding(.vertical, 12)
//                .background(
//                    RoundedRectangle(cornerRadius: 14)
//                        .fill(backgroundColor.opacity(0.95))
//                )
//                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
//                .padding(.bottom, 60)
//                .transition(.move(edge: .bottom).combined(with: .opacity))
//                .onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
//                        withAnimation(.easeInOut(duration: 0.3)) {
//                            isVisible = false
//                        }
//                    }
//                }
//            }
//        }
//        .animation(.easeInOut(duration: 0.3), value: isVisible)
//    }
//}
import SwiftUI

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
                .onAppear {
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
