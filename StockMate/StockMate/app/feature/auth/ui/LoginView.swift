//
//  LoginView.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//


import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    
    @State private var emailError: String? = nil
    @State private var pwError: String? = nil
    
//    var onLoginSuccess: () -> Void = {}
    var onLogin: (String, String) -> Void = { _, _ in }
    var onClickRegister: () -> Void = {}
    
    var body: some View {
        VStack {
            Spacer().frame(height: 140)
            
            // MARK: - Logo
            Image("stockmate_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 216, height: 44)
            
            Spacer().frame(height: 67)
            
            // MARK: - Title
            Text("로그인")
                .font(.system(size: 28, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .foregroundColor(Color.DarkBlue01)
            
            Spacer().frame(height: 17)
            
            // MARK: - Text Fields
            CustomTextField(
                title: "이메일",
                placeholder: "stockmate@gmail.com",
                text: $authViewModel.email,
                isEmail: true,
                errorMessage: emailError
            )
            .keyboardType(.emailAddress)
            .padding(.horizontal, 24)
            
            Spacer().frame(height: 18)
            
            // 비밀번호
            CustomSecureField(
                title: "비밀번호",
                placeholder: "비밀번호를 입력하세요",
                text: $authViewModel.password,
                errorMessage: pwError
            )
            .padding(.horizontal, 24)
            
            Spacer().frame(height: 56)
            
            // MARK: - Login Button
            Button(action: {
                if isValidForm() {
                    Task {
                        await authViewModel.login()
                    }
                }
            }) {
                Text("로그인")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(Color.Primary)
                    .cornerRadius(4)
            }
            .padding(.horizontal, 24)
            
            Spacer().frame(height: 24)
            
            // 회원가입 링크
            HStack {
                Text("계정이 없으신가요?")
                    .foregroundColor(Color.Secondary)
                    .font(.system(size: 13))
                Button(action: { onClickRegister() }) {
                    Text("회원가입")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color.Secondary)
                }
            }
            Spacer()
        }
        .background(Color.Light)
        .ignoresSafeArea()
    }
    
    // MARK: - 유효성 검사 함수
    private func isValidForm() -> Bool {
        emailError = isValidEmail(authViewModel.email) ? nil : "이메일 형식을 확인해주세요"
        pwError = authViewModel.password.count >= 8 ? nil : "8자 이상 비밀번호를 입력해주세요"
        return emailError == nil && pwError == nil
    }
    
}
