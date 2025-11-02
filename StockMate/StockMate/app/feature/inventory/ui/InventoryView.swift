//
//  InventoryView.swift
//  StockMate
//
//  Created by Admin on 10/12/25.
//

import SwiftUI
struct InventoryView: View {
    @Binding var selectedTab: Int
    @Binding var tabTappedTrigger: Bool
    
    @StateObject private var inventoryViewModel = InventoryViewModel()
    @State private var showScrollToTopButton = false
    @Namespace private var topID
    
    @State private var lastTabSelection = 0

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ZStack {
                    ScrollView {
                        VStack(spacing: 0) {
                            // 스크롤 감지용 (맨 위)
                            GeometryReader { geo in
                                Color.clear
                                    .onChange(of: geo.frame(in: .global).minY) { newValue in
                                        // 👇 스크롤 시 값이 변함
                                        //print("📏 Scroll offsetY:", newValue)   // 테스트용, 화면 안정화 후 제거
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            showScrollToTopButton = newValue < -150
                                        }
                                    }
                            }
                            .frame(height: 0)
                            .id(topID)

                            // 타이틀
                            Text("재고 관리")
                                .font(.title2)
                                .bold()
                                .padding(.top, 13)
                                .padding(.leading, 25)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            GridMenuView()

                            Text("얼마 남지 않았어요!")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 25)
                                .padding(.top)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            LazyVStack(spacing: 12) {
                                ForEach(inventoryViewModel.underLimitItems) { item in
                                    InventoryCardView(item: item)
                                        .padding(.horizontal)
                                        .onAppear {
                                            if item.id == inventoryViewModel.underLimitItems.last?.id {
                                                Task {
                                                    await inventoryViewModel.loadUnderLimitList()
                                                }
                                            }
                                        }
                                }

                                if inventoryViewModel.isLoading {
                                    ProgressView()
                                        .padding(.vertical, 20)
                                }
                            }
                            .padding(.top, 8)
                            .padding(.bottom, 80)
                        }
                    }

                    // 오른쪽 하단 플로팅 버튼
                    if showScrollToTopButton {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button {
                                    withAnimation(.easeInOut) {
                                        proxy.scrollTo(topID, anchor: .top)
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(Color.Primary) // 배경색
                                            .frame(width: 50, height: 50)
                                        Image(systemName: "arrow.up")
                                            .font(
                                                .system(size: 24, weight: .bold)
                                            )
                                            .foregroundColor(.white) // 화살표 색
                                    }
                                }
                                .padding(.trailing, 20)
                                .padding(.bottom, 20)
                            }
                        }
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.25), value: showScrollToTopButton)
                    }
                }
                .background(Color.Light)
                .task {
                    await inventoryViewModel.loadUnderLimitList(reset: true)
                }
                // 같은 탭 다시 눌릴 때 위로 스크롤
                 .onChange(of: tabTappedTrigger) { _ in
                     withAnimation(.easeInOut) {
                         proxy.scrollTo(topID, anchor: .top)
                     }
                 }
            }
        }
    }
}

struct GridMenuView: View {
    let menuItems = [
        ("재고 조회", true, "InvStock", AnyView(InventorySearchView())),
        ("입출고 히스토리", false, "InvTrans", AnyView(InOutHistoryView())),
        ("입고 처리", false, "InvIncoming", AnyView(IncomingScanView())),
        ("사용 처리", true, "InvUse", AnyView(OutgoingScanView())),
    ]
    
    var body: some View {
        VStack(spacing: 15) {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10),
                ],
                spacing: 10
            ) {
                ForEach(menuItems, id: \.0) { item in
                    NavigationLink(destination: item.3) {
                        VStack(alignment: .leading, spacing: 19) {
                            HStack {
                                Spacer()
                                ZStack {
                                    // 타원 배경
                                    Rectangle()
                                        .fill(item.1 ? Color.white.opacity(0.2) : Color.Primary)
                                        .frame(width: 35, height: 26)
                                        .cornerRadius(80)
                                    
                                    // 아이콘
                                    Image(item.2)
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 14, height: 14)
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Text(item.0)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(item.1 ? .white : Color.Primary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .frame(height: 99)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(item.1 ? Color.Primary : Color.white)
                                // 카드 그림자 (Figma 스펙: y=4, blur=4, opacity=25%, black)
                                .shadow(color: .black.opacity(0.35), radius: 2, x: 0, y: 4)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 15)
        }
        .padding(.vertical, 17)
    }
}
