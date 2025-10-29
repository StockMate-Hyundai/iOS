//
//  IncomingScanView.swift
//  StockMate
//
//  Created by Admin on 10/13/25.
//

import SwiftUI

struct IncomingScanView: View {
    var body: some View {
        VStack(spacing: 30) {
            // 상단 타이틀
            Text("입고 부품의 QR을 스캔해주세요")
                .font(.headline)
                .padding(.top, 30)
            
            // 스캔 영역
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 250, height: 250)
                
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 3)
                    .frame(width: 220, height: 220)
            }
            .padding(.top, 20)
            
            Spacer()
            
            // 직접 등록 버튼
            Button(action: {
                print("직접 등록 tapped")
            }) {
                Text("직접 등록 하기")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 2)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        .navigationTitle("입고 부품 등록")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        IncomingScanView()
    }
}
