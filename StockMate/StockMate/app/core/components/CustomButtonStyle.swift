//
//  CustomButtonStyle.swift
//  StockMate
//
//  Created by Admin on 11/4/25.
//


import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    enum StyleType {
        case filled(Color)
        case outlined(Color)
    }

    var type: StyleType
    var height: CGFloat = 52
    var cornerRadius: CGFloat = 9999
    var fontSize: CGFloat = 16
    var fontWeight: Font.Weight = .semibold

    func makeBody(configuration: Configuration) -> some View {
        switch type {
        case .filled(let color):
            configuration.label
                .frame(maxWidth: .infinity, minHeight: height)
                .background(color.opacity(configuration.isPressed ? 0.8 : 1))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .foregroundColor(.white)
                .font(.system(size: fontSize, weight: fontWeight))
                .animation(.easeOut(duration: 0.15), value: configuration.isPressed)

        case .outlined(let color):
            configuration.label
                .frame(maxWidth: .infinity, minHeight: height)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(color, lineWidth: 1)
                )
                .foregroundColor(color)
                .font(.system(size: fontSize, weight: fontWeight))
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.white)
                )
                .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
        }
    }
}
