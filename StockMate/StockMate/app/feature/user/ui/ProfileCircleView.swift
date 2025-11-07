//
//  ProfileCircleView.swift
//  StockMate
//
//  Created by Admin on 10/14/25.
//

import SwiftUI

struct ProfileCircleView: View {
    let name: String
    let size: CGFloat

    private var initials: String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let firstTwo = trimmed.prefix(2)
        return String(firstTwo)
    }

    var body: some View {
        GeometryReader { geometry in
            let minSide = min(geometry.size.width, geometry.size.height)
            Text(initials)
                .font(.system(size: minSide * 0.35, weight: .regular)) // ✅ 내부 크기 비례
                .foregroundColor(Color(hex: "#374EAF"))
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color(hex: "#DCE0F1"))
                .clipShape(Circle())
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    ProfileCircleView(name: "유현아", size: 50)
}
