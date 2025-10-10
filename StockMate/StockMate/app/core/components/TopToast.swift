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
    var duration: Double = 2.2

    var body: some View {
        if isVisible {
            VStack {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.white)
                    Text(message)
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .medium))
                }
                .padding()
                .background(Color.red.opacity(0.9))
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.horizontal, 16)
                .padding(.top, 8)

                Spacer()
            }
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.easeInOut(duration: 0.25), value: isVisible)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    withAnimation {
                        isVisible = false
                    }
                }
            }
        }
    }
}
