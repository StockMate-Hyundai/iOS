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
    
    // 토스트 관련 상태 추가
    @State private var showTopToast = false
    @State private var topToastMessage = ""
    
    var onLogin: (String, String) -> Void = { _, _ in }
    var onClickRegister: () -> Void = {}
    
    var body: some View {
        ZStack {
            
            
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
                .onChange(of: authViewModel.email) { newValue in
                    // 입력 중 실시간 validation
                    emailError = isValidEmail(newValue) ? nil : "이메일 형식을 확인해주세요"
                }
                
                Spacer().frame(height: 18)
                
                // 비밀번호
                CustomSecureField(
                    title: "비밀번호",
                    placeholder: "비밀번호를 입력하세요",
                    text: $authViewModel.password,
                    errorMessage: pwError
                )
                .padding(.horizontal, 24)
                .onChange(of: authViewModel.password) { newValue in
                    pwError = newValue.count >= 8 ? nil : "8자 이상 비밀번호를 입력해주세요"
                }
                
                Spacer().frame(height: 26)
                
                // MARK: - Login Button
                // 3) 버튼 — 시각적 상태 반영 + disabled 처리
                Button(action: {
                    // 버튼이 눌렸을 때는 한번 더 확정적으로 에러 상태를 설정
                    // (뷰 업데이트 중이 아니므로 상태 변경해도 안전)
                    validateAndSetErrors()
                    guard isFormValid else { return }
                    
                    Task {
                        let success = await authViewModel.login()
                        if !success {
                            showToast("아이디 또는 비밀번호가 잘못되었습니다.")
                        }
                        //                    await authViewModel.login()
                    }
                }) {
                    Text("로그인")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(isFormValid ? Color.Primary : Color.gray.opacity(0.45))
                        )
                        .cornerRadius(4)
                }
                .padding(.horizontal, 24)
                .disabled(!isFormValid)
                
                
                Spacer().frame(height: 24)
                
                // 회원가입 링크
                HStack {
                    Text("계정이 없으신가요?")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 13))
                    Button(action: { onClickRegister() }) {
                        Text("회원가입")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.Primary)
                    }
                }
                
                Spacer()
                
            }
            .background(Color.Light)
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
            .ignoresSafeArea()
            
            TopToast(message: topToastMessage,
                     isVisible: $showTopToast,
                     iconName: "exclamationmark.circle",
                     iconColor: .black)
            .zIndex(1) // 다른 뷰 위로
 
            
        }
    }
    
    // MARK: - 유효성 검사 함수
    // 1) 뷰 내부(바디 바깥) — 부작용 없는 computed property
    private var isFormValid: Bool {
        return isValidEmail(authViewModel.email) && authViewModel.password.count >= 8
    }

    // 4) body 바깥에 유틸 함수 추가 — 뷰 업데이트 중 호출하지 말고 이벤트에서만 호출
    private func validateAndSetErrors() {
        // 이 함수는 호출되는 시점이 사용자 액션(버튼)일 때만 사용
        emailError = isValidEmail(authViewModel.email) ? nil : "이메일 형식을 확인해주세요"
        pwError = authViewModel.password.count >= 8 ? nil : "8자 이상 비밀번호를 입력해주세요"
    }

    // 상단 토스트 표시 함수
       private func showToast(_ message: String) {
           topToastMessage = message
           withAnimation {
               showTopToast = true
           }
       }
    
}
