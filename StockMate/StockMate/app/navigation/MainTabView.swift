//
//  MainTabView.swift
//  StockMate
//
//  Created by Admin on 10/7/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var cartVM = CartViewModel()
    
    @State private var selectedTab = 0
    @State private var tabTappedTrigger = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 메인 화면
            ZStack {
                switch selectedTab {
                case 0: NavigationStack{ HomeView() }
                case 1: NavigationStack{ OrderView(cartViewModel: cartVM) } //, inventoryViewModel: inventoryVM) }
//                case 1: NavigationStack{ OrderView() }
                case 2:
                NavigationStack { InventoryView(selectedTab: $selectedTab, tabTappedTrigger: $tabTappedTrigger) }
//                case 3: NavigationStack{ ContentView() }
                case 3: NavigationStack{ ReceiptView() }
//                case 3: NavigationStack{ ProfileView() }
                default: NavigationStack{ ContentView() }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // 커스텀 탭바
            HStack {
                tabButton(index: 0, icon: "tabHome", text: "홈")
                tabButton(index: 1, icon: "tabPackage", text: "발주")
                tabButton(index: 2, icon: "tabInventory", text: "재고관리")
                tabButton(index: 3, icon: "tabProfile", text: "사용자")
            }
            .padding(.vertical, 24)  // 탭 높이 조절
            .padding(.horizontal, 20)
            .background(Color.White) // 탭바 배경색
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // 커스텀 탭 버튼
    func tabButton(index: Int, icon: String, text: String) -> some View {
        let isSelected = selectedTab == index
        return Button {
            if selectedTab == index {
            // ✅ 같은 탭 다시 누르면 트리거 토글
                tabTappedTrigger.toggle()
            } else {
                withAnimation(.easeInOut) {
                    selectedTab = index
                }
            }
//            withAnimation(.easeInOut) { // 탭 전환 애니메이션. 없애도 됨
//                selectedTab = index
//            }
        } label: {
            VStack(spacing: 6) {
                Image(icon)
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(height: 20)
                    .foregroundColor(isSelected ? Color.Primary : Color.textGray2)
                
                Text(text)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(isSelected ? Color.Primary : Color.textGray2)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
