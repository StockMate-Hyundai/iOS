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

    @State private var showAddressSearch = false

    
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
                    // ✅ 주소 입력 필드 + 버튼 추가 부분
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            CustomTextField(
                                title: "주소",
                                placeholder: "서울특별시 강남구 ...",
                                text: $address,
                                errorMessage: addressError,
                                isReadOnly: true // ✅ 추가
                            )
                            .disabled(true) // 사용자가 직접 입력 못하게
                            .onTapGesture {
                                // 탭해도 검색창 열 수 있게 (선택사항)
                                showAddressSearch.toggle()
                            }

                            Button(action: {
                                showAddressSearch.toggle()
                            }) {
                                Text("주소 검색")
                                    .font(.system(size: 14, weight: .semibold))
                                    .frame(height: 43)
                                    .padding(.horizontal, 12)
                                    .background(Color.Primary)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .sheet(isPresented: $showAddressSearch) {
                                KakaoZipCodeView(address: $address)
                            }
                        }
                    }
                    CustomTextField(
                        title: "사업자등록번호",
                        placeholder: "123-45-67890",
                        text: $bizNo,
                        errorMessage: bizNoError
                    )
                    .keyboardType(.numberPad)
                    .onChange(of: bizNo) { newValue in
                        formatBizNoInput(newValue)
                    }
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
                
                // ✅ 키보드 가림 방지용 여백
                Spacer().frame(height: 300)
            }
        }
        .background(Color.Light)
        .ignoresSafeArea()
        .scrollDismissesKeyboard(.interactively) // ✅ 손가락으로 스크롤하면 키보드 자동 내려감

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
                bizNo: bizNo.filter { $0.isNumber } // ← 여기서 숫자만 추출해서 전송
            )
            isLoading = false
        }
    }
    
    private func formatBizNoInput(_ input: String) {
        // 1️⃣ 숫자만 남기기
        let digitsOnly = input.filter { $0.isNumber }

        // 2️⃣ 하이픈 자동 삽입
        var formatted = ""
        let length = digitsOnly.count

        if length <= 3 {
            formatted = digitsOnly
        } else if length <= 5 {
            formatted = "\(digitsOnly.prefix(3))-\(digitsOnly.suffix(from: digitsOnly.index(digitsOnly.startIndex, offsetBy: 3)))"
        } else {
            let first = digitsOnly.prefix(3)
            let middleStart = digitsOnly.index(digitsOnly.startIndex, offsetBy: 3)
            let middleEnd = digitsOnly.index(middleStart, offsetBy: 2, limitedBy: digitsOnly.endIndex) ?? digitsOnly.endIndex
            let middle = digitsOnly[middleStart..<middleEnd]
            let last = digitsOnly.suffix(from: middleEnd)
            formatted = "\(first)-\(middle)-\(last)"
        }

        // 3️⃣ 10자리 이상은 자르기
        if digitsOnly.count > 10 {
            formatted = String(formatted.prefix(12)) // 하이픈 포함
        }

        // 4️⃣ 상태 업데이트
        if formatted != bizNo {
            bizNo = formatted
        }
    }
}

