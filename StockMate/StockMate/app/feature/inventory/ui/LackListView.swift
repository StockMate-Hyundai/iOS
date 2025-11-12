//
//  LackListView.swift
//  StockMate
//
//  Created by Admin on 10/23/25.
//

import SwiftUI

struct LackListView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var inventoryViewModel = InventoryViewModel()
    @State private var isFirstAppear = true
    
    // 전달받는 초기 카테고리
    @State var selectedCategory: String
    private let categories = ["전기/램프", "엔진/미션", "하체/바디", "내장/외장", "기타소모품"]
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 카테고리 탭 (가로 스크롤 가능)
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { category in
                                CategoryButton(
                                    title: category,
                                    isSelected: selectedCategory == category
                                ) {
                                    Task {
                                        selectedCategory = category
                                        inventoryViewModel.selectedCategories = [category]
                                        await inventoryViewModel.loadUnderLimitList(reset: true)
                                        
                                        // 버튼 클릭 시 해당 카테고리로 스크롤 이동
                                        withAnimation {
                                            proxy.scrollTo(category, anchor: .center)
                                        }
                                    }
                                }
                                .id(category) // ScrollViewReader용 id
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    }
                    .onAppear {
                        // 진입 시 선택된 카테고리 위치로 자동 스크롤
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation {
                                proxy.scrollTo(selectedCategory, anchor: .center)
                            }
                        }
                    }
                }

            
            // 리스트
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(inventoryViewModel.underLimitItems) { item in
                        InventoryCardView(item: item)
                            .padding(.horizontal)
                            .onAppear {
                                // 무한 스크롤 트리거
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
        .background(Color.Light)
        .navigationTitle("부족 재고")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundColor(.black)
                }
            }
        }
        .task {
            if isFirstAppear {
                isFirstAppear = false
                inventoryViewModel.selectedCategories = [selectedCategory]
                await inventoryViewModel.loadUnderLimitList(reset: true)
            }
        }
    }
}

