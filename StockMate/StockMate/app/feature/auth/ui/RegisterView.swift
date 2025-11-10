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
    @State private var showSuccessToast = false
    
    var body: some View {
        ZStack {
            
            
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
                        .onChange(of: email) { newValue in
                            emailError = isValidEmail(newValue) ? nil : "이메일 형식을 확인해주세요"
                        }
                        CustomSecureField(
                            title: "비밀번호",
                            placeholder: "비밀번호를 입력하세요",
                            text: $password,
                            errorMessage: pwError
                        )
                        .onChange(of: password) { newValue in
                            pwError = isValidPassword(newValue) ? nil : "8자 이상, 영문+숫자 조합입니다."
                            // confirm도 재검증
                            confirmPasswordError = (confirmPassword.isEmpty || confirmPassword == newValue) ? nil : "비밀번호가 일치하지 않습니다"
                        }
                        
                        CustomSecureField(
                            title: "비밀번호 확인",
                            placeholder: "비밀번호를 다시 입력하세요",
                            text: $confirmPassword,
                            errorMessage: confirmPasswordError
                        )
                        .onChange(of: confirmPassword) { newValue in
                            confirmPasswordError = (password == newValue) ? nil : "비밀번호가 일치하지 않습니다"
                        }
                        CustomTextField(
                            title: "대표자 이름",
                            placeholder: "홍길동",
                            text: $owner,
                            errorMessage: nil
                        )
                        CustomTextField(
                            title: "지점 이름",
                            placeholder: "강남점",
                            text: $storeName,
                            errorMessage: nil
                        )
                        // ✅ 주소 입력 필드 + 버튼 추가 부분
                        VStack(alignment: .leading, spacing: 4) {
                            CustomTextField(
                                title: "주소",
                                placeholder: "도로명 주소를 검색하세요",
                                text: $address,
                                errorMessage: addressError,
                                isReadOnly: true // ✅ 추가
                            )
                            .disabled(true) // 사용자가 직접 입력 못하게
                            .onTapGesture {
                                // 탭해도 검색창 열 수 있게 (선택사항)
                                showAddressSearch.toggle()
                            }
                            .sheet(isPresented: $showAddressSearch) {
                                KakaoZipCodeView(address: $address)
                            }
                        }
                        
                        CustomTextField(
                            title: "사업자등록번호",
                            placeholder: "000-00-00000",
                            text: $bizNo,
                            errorMessage: bizNoError
                        )
                        .keyboardType(.numberPad)
                        .onChange(of: bizNo) { newValue in
                            formatBizNoInput(newValue)
                            bizNoError = isValidBizNo(newValue) ? nil : "형식: 000-00-00000"
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    
                    // MARK: - Register Button
                    if isLoading {
                        ProgressView("회원가입 중...")
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Button(action: {
                            validateAndSetErrors()
                            guard isFormValid else { return }
                            Task {
                                isLoading = true
                                let success = await viewModel.register(
                                    email: email,
                                    password: password,
                                    owner: owner,
                                    address: address,
                                    storeName: storeName,
                                    bizNo: bizNo.filter { $0.isNumber }
                                )
                                isLoading = false
                                
                                // ✅ 회원가입 성공 시 토스트 표시
//                                if success {
//                                    withAnimation {
//                                        showSuccessToast = true
//                                    }
//                                }
                            }
                        }) {
                            Text("회원가입")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(isFormValid ? Color.Primary : Color.gray.opacity(0.45))
                                )
                                .cornerRadius(8)
                        }
                        .disabled(!isFormValid)
                        .padding(.horizontal, 24)
                    }
                    
                    TopToast(message: viewModel.message, isVisible: $showToast)
                    
                    Spacer().frame(height: 5)
                    // MARK: - Login Link
                    HStack(spacing: 4) {
                        Text("이미 계정이 있으신가요?")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 13))
                        Button(action: {
                            viewModel.goToLogin()
                            print("로그인으로 이동")
                        }) {
                            Text("로그인")
                                .fontWeight(.semibold)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color.Primary)
                        }
                    }
                    .padding(.bottom, 40)
                    
                    // ✅ 키보드 가림 방지용 여백
                    Spacer().frame(height: 300)
                }
            }
            .background(Color.Light)
            .ignoresSafeArea()
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
            .scrollDismissesKeyboard(.interactively) // ✅ 손가락으로 스크롤하면 키보드 자동 내려감
            // showToast 자동으로 트리거: viewModel.message 변경 시 토스트 보여주기
            .onChange(of: viewModel.message) { newMsg in
                guard !newMsg.isEmpty else { return }
                showToast = true
            }
            
            // ✅ 회원가입 성공 토스트
            BottomToast(
                message: "회원가입 성공",
                isVisible: $showSuccessToast,
                iconName: "toastlogo",
                backgroundColor: Color(hex: "EEEDF5") // 초록색
            )
            .zIndex(1) // 다른 뷰 위로
        }
       
    }

    // MARK: - 유효성 검사 함수
 
    
    // MARK: - computed form valid (부작용 없음)
      private var isFormValid: Bool {
          return isValidEmail(email)
              && isValidPassword(password)
              && password == confirmPassword
              && !owner.trimmingCharacters(in: .whitespaces).isEmpty
              && !storeName.trimmingCharacters(in: .whitespaces).isEmpty
              && !address.trimmingCharacters(in: .whitespaces).isEmpty
              && isValidBizNo(bizNo)
      }
    
    // MARK: - validate & helpers
    private func validateAndSetErrors() {
        emailError = isValidEmail(email) ? nil : "이메일 형식을 확인해주세요"
        pwError = isValidPassword(password) ? nil : "8자 이상, 영문+숫자 조합입니다."
        confirmPasswordError = (password == confirmPassword) ? nil : "비밀번호가 일치하지 않습니다"
        addressError = address.isEmpty ? "주소를 입력해주세요." : nil
        bizNoError = isValidBizNo(bizNo) ? nil : "형식: 000-00-00000"
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

