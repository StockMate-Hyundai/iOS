//
//  StockMateApp.swift
//  StockMate
//
//  Created by Admin on 10/5/25.
//

import SwiftUI

@main
struct StockMateApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var isLoading = true     // 인트로 상태
    
    var body: some Scene {
        WindowGroup {
            
            Group {
                if isLoading {
                    IntroView()             // 로고만 보여주는 화면
                } else {
                    AppNavHost()
                        .environmentObject(authViewModel)
                }
            }
            .onAppear {
                Task {
                    try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5초
                    isLoading = false
                }
            }
        }
    }
}
