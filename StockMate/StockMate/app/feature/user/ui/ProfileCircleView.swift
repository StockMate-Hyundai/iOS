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
        Text(initials)
            .font(.headline)
            .foregroundColor(Color(hex: "#374EAF"))
            .frame(width: size, height: size)
            .background(Color(hex: "#DCE0F1")) // 고정 색상
            .clipShape(Circle())
    }
}

#Preview {
    ProfileCircleView(name: "유현아", size: 50)
}
