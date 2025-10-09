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
    
    var body: some Scene {
        WindowGroup {
            AppNavHost()
                .environmentObject(authViewModel)
        }
    }
}
