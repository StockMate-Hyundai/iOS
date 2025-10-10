//
//  MainTabView.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }.tag(0)
            
//            SearchView()
            ContentView()
                .tabItem {
                    Label("발주", systemImage: "magnifyingglass")
                }.tag(1)
            
//            NotificationView()
            ContentView()
                .tabItem {
                    Label("재고관리", systemImage: "bell.fill")
                }.tag(2)
            
//            MyPageView()
            ContentView()
                .tabItem {
                    Label("사용자", systemImage: "person.fill")
                }.tag(3)
        }
    }
}

