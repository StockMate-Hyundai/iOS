//
//  AppNavHost.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import SwiftUI

// 앱의 전반적인 네비게이션 흐름을 관리하는 뷰
struct AppNavHost: View {
    @EnvironmentObject var authViewModel: AuthViewModel // 인증 상태 관리 뷰모델
    @StateObject private var partStore = PartStore()    // 부품 관련 상태 저장소
    
    
    var body: some View {
        NavigationStack {
            switch authViewModel.authState {
                case .unauthenticated:
                    // 로그인되지 않은 경우 → 로그인 화면 표시
                    LoginView(onClickRegister: {
                        authViewModel.goToRegister()
                    })
                case .registering:
                    // 회원가입 중인 경우 → 회원가입 화면 표시
                    RegisterView()
                case .authenticated:
                    // 로그인 완료된 경우 → 메인 탭 화면 표시
                    MainTabView()
                    .environmentObject(authViewModel) 
                    .environmentObject(partStore)
            }
        }
    }
}

