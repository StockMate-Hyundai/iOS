//
//  RegisterView.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var viewModel: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var owner = ""
    @State private var storeName = ""
    @State private var address = ""
    @State private var bizNo = ""

    // 에러 메시지 상태
    @State private var emailError: String? = nil
    @State private var pwError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @State private var ownerError: String? = nil
    @State private var storeNameError: String? = nil
    @State private var addressError: String? = nil
    @State private var bizNoError: String? = nil

    @State private var isLoading = false
    @State private var showToast = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer().frame(height: 70)

                // MARK: - Logo
                Image("stockmate_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 216, height: 44)

                Spacer().frame(height: 4)

                // MARK: - Title
                Text("회원가입")
                    .font(.system(size: 28, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .foregroundColor(Color.DarkBlue01)

                // MARK: - Text Fields
                VStack {
                    CustomTextField(
                        title: "이메일",
                        placeholder: "stockmate@gmail.com",
                        text: $email,
                        errorMessage: emailError
                    )
                    .keyboardType(.emailAddress)
                    CustomSecureField(
                        title: "비밀번호",
                        placeholder: "비밀번호를 입력하세요",
                        text: $password,
                        errorMessage: pwError
                    )
                    CustomSecureField(
                        title: "비밀번호 확인",
                        placeholder: "비밀번호를 다시 입력하세요",
                        text: $confirmPassword,
                        errorMessage: confirmPasswordError
                    )
                    CustomTextField(
                        title: "대표자 이름",
                        placeholder: "홍길동",
                        text: $owner,
                        errorMessage: ownerError
                    )
                    CustomTextField(
                        title: "지점 이름",
                        placeholder: "서울 1호점",
                        text: $storeName,
                        errorMessage: storeNameError
                    )
                    CustomTextField(
                        title: "주소",
                        placeholder: "서울특별시 강남구 ...",
                        text: $address,
                        errorMessage: addressError
                    )
                    CustomTextField(
                        title: "사업자등록번호",
                        placeholder: "123-45-67890",
                        text: $bizNo,
                        errorMessage: bizNoError
                    )
                    .keyboardType(.numbersAndPunctuation)
                }
                .padding(.horizontal, 24)
                

                // MARK: - Register Button
                if isLoading {
                    ProgressView("회원가입 중...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Button(action: {
                        handleRegister()
                    }) {
                        Text("회원가입")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color(hex: "#1D4ED8"))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 24)
                }

                TopToast(message: viewModel.message, isVisible: $showToast)

                Spacer().frame(height: 5)
                // MARK: - Login Link
                HStack(spacing: 4) {
                    Text("이미 계정이 있으신가요?")
                        .foregroundColor(Color.Secondary)
                        .font(.system(size: 13))
                    Button(action: {
                        viewModel.goToLogin()
                        print("로그인으로 이동")
                    }) {
                        Text("로그인")
                            .fontWeight(.semibold)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color.Secondary)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .background(Color.Light)
        .ignoresSafeArea()
    }

    // MARK: - 유효성 검사 함수
    private func isValidForm() -> Bool {
        emailError = isValidEmail(email) ? nil : "이메일 형식을 확인해주세요"
        pwError = isValidPassword(password) ? nil : "영문과 숫자를 포함한 8자 이상 비밀번호를 입력해주세요"
        confirmPasswordError = (password == confirmPassword) ? nil : "비밀번호가 일치하지 않습니다."
        bizNoError = isValidBizNo(bizNo) ? nil : "사업자등록번호 형식이 올바르지 않습니다. (예: 123-45-67890)"

        return emailError == nil && pwError == nil
            && confirmPasswordError == nil && bizNoError == nil
    }

    // MARK: - Register Handler
    private func handleRegister() {
        // 초기화
        emailError = nil
        pwError = nil
        confirmPasswordError = nil
        ownerError = nil
        storeNameError = nil
        addressError = nil
        bizNoError = nil

        var hasEmptyField = false

        // 필수 필드 체크
        if email.isEmpty {
            emailError = "이메일을 입력해주세요."
            hasEmptyField = true
        }
        if password.isEmpty {
            pwError = "비밀번호를 입력해주세요."
            hasEmptyField = true
        }
        if confirmPassword.isEmpty {
            confirmPasswordError = "비밀번호를 다시 입력해주세요."
            hasEmptyField = true
        }
        if owner.isEmpty {
            ownerError = "대표자 이름을 입력해주세요."
            showToast = true
        }
        if storeName.isEmpty {
            storeNameError = "지점 이름을 입력해주세요."
            showToast = true
        }
        if address.isEmpty {
            addressError = "주소를 입력해주세요."
            showToast = true
        }
        if bizNo.isEmpty {
            bizNoError = "사업자등록번호를 입력해주세요."
            hasEmptyField = true
        }

        // 빈 칸이 하나라도 있으면 종료
        guard !hasEmptyField else { return }
        // 유효성 검사 함수 실행
        guard isValidForm() else { return }

        // 통과 → 회원가입 진행
        Task {
            isLoading = true
            await viewModel.register(
                email: email,
                password: password,
                owner: owner,
                address: address,
                storeName: storeName,
                bizNo: bizNo
            )
            isLoading = false
        }
    }
}
