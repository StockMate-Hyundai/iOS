//
//  AppNavHost.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import SwiftUI

struct AppNavHost: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var partStore = PartStore()
    
    
    var body: some View {
        NavigationStack {
            switch authViewModel.authState {
                
                case .unauthenticated:
                    LoginView(onClickRegister: {
                        authViewModel.goToRegister()
                    })
                case .registering:
                    RegisterView()
                case .authenticated:
                    MainTabView()
                    .environmentObject(authViewModel) 
                    .environmentObject(partStore)
            }
        }
    }
}

