//
//  IntroView.swift
//  StockMate
//
//  Created by Admin on 11/10/25.
//

import SwiftUI

struct IntroView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea() // 배경 흰색

            Image("intrologo") // Assets에 있는 이미지 이름
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180) // 필요시 크기 조정
        }
    }
}
