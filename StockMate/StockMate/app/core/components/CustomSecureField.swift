//
//  CustomSecureField.swift
//  StockMate
//
//  Created by Admin on 10/9/25.
//

import SwiftUI

struct CustomSecureField: View {
    var title: String
    var placeholder: String
    @Binding var text: String
    var errorMessage: String? = nil
    
    @FocusState private var isFocused: Bool
    @State private var showPassword = false
    
    // 테두리 색상 계산 로직 (CustomTextField와 동일)
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
            // 필드 제목
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.black)
            
            // 텍스트 입력 박스
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(borderColor, lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                    // 포커스일 때만 그림자 표시
                    .shadow(
                        color: isFocused
                            ? Color(hex: "#333333").opacity(0.1)
                            : Color.clear,
                        radius: 1,
                        x: 0,
                        y: 2
                    )
                
                HStack {
                    if showPassword {
                        TextField(placeholder, text: $text)
                    } else {
                        SecureField(placeholder, text: $text)
                    }
                    
                    Spacer()
                    
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .focused($isFocused)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            }
            .frame(height: 46)
            
            Text(errorMessage ?? " ")
                .font(.caption)
                .foregroundColor(.red)
                .frame(height: 14) // 고정 높이 확보
        }
    }
}
