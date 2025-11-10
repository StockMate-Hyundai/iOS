//
//  CustomTextField.swift
//  StockMate
//
//  Created by Admin on 10/9/25.
//

import SwiftUI

struct CustomTextField: View {
    var title: String
    var placeholder: String
    @Binding var text: String
    var isEmail: Bool = false
    var errorMessage: String? = nil
    var isReadOnly: Bool = false   // ✅ 추가
    
    @FocusState private var isFocused: Bool
    
    // ✅ 테두리 색상 계산 로직
    private var borderColor: Color {
        if let error = errorMessage, !error.isEmpty {
            return .red
        } else if isFocused {
            return .Primary
        } else {
            return .LightBlue04
        }
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.black)
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
//                    .strokeBorder(
//                        isFocused
//                            ? Color.Primary
//                            : (errorMessage == nil ? Color.LightBlue04 : .red),
//                        lineWidth: 1
//                    )
                
                    .strokeBorder(borderColor, lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                    )
                    // 포커스일 때만 그림자 표시
                    .shadow(
                        color: isFocused
                            ? Color(hex: "#333333").opacity(0.1)
                            : Color.clear,
                        radius: 1,
                        x: 0,
                        y: 2
                    )
               
                if isReadOnly {
                    // ✅ 가로 스크롤 가능한 읽기 전용 텍스트
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(text.isEmpty ? placeholder : text)
                            .font(.system(size: 15))
                            .foregroundColor(text.isEmpty ? .gray : .black)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .lineLimit(1)
                    }
                    .frame(height: 46)
                    .contentShape(Rectangle())
                    
                } else {
                    TextField(placeholder, text: $text)
                        .focused($isFocused)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }                
            }
            .frame(height: 46) // 높이 일정하게 고정
            
            Text(errorMessage ?? " ")
                .font(.caption)
                .foregroundColor(.red)
                .frame(height: 14) // 고정 높이 확보
                .opacity(errorMessage == nil ? 0 : 1) // 없을 땐 투명
//            if let errorMessage = errorMessage {
//                Text(errorMessage)
//                    .font(.caption)
//                    .foregroundColor(.red)
//            }
        }
    }
}
