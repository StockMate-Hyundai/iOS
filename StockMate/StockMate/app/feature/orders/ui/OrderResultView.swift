//
//  OrderResultView.swift
//  StockMate
//
//  Created by Admin on 10/20/25.
//

import SwiftUI

struct OrderResultView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            
            // ✅ 결제 완료 아이콘
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
                .padding(.bottom, 8)
            
            // ✅ 완료 문구
            Text("결제가 완료되었습니다")
                .font(.title3)
                .bold()
            Text("주문 내역은 발주 탭에서 확인할 수 있습니다.")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            // ✅ 하단 버튼
            VStack(spacing: 12) {
                Button {
                    dismiss() // 이전 화면으로 돌아가기
                } label: {
                    Text("확인")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                
                Button {
                    // 홈으로 이동 (추후 NavigationStack 연결 시)
                } label: {
                    Text("홈으로 이동")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.blue)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationTitle("결제 완료")
    }
}

#Preview {
    OrderResultView()
}
