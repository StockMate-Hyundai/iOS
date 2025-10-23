//
//  LackListView.swift
//  StockMate
//
//  Created by Admin on 10/23/25.
//

import SwiftUI

struct LackListView: View {
    @StateObject private var inventoryViewModel = InventoryViewModel()
    @State private var isFirstAppear = true
    
    // 전달받는 초기 카테고리
    @State var selectedCategory: String
    private let categories = ["전기/램프", "엔진/미션", "하체/바디", "내장/외장", "기타소모품"]
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 카테고리 탭
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
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
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
        .task {
            if isFirstAppear {
                isFirstAppear = false
                inventoryViewModel.selectedCategories = [selectedCategory]
                await inventoryViewModel.loadUnderLimitList(reset: true)
            }
        }
    }
}

#Preview {
    LackListView(selectedCategory: "엔진/미션")
        .environmentObject(InventoryViewModel())
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(isSelected ? .Primary : .black)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.Light)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.Primary : Color.GrayStroke, lineWidth: 1)
                )
        }
    }
}
