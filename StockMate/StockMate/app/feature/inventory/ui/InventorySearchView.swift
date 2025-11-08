//
//  InventorySearchView.swift
//  StockMate
//
//  Created by Admin on 10/15/25.
//


import SwiftUI

struct InventorySearchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var inventoryViewModel = InventoryViewModel()
    @State private var searchText = ""
    
    // 카테고리, 분류, 모델
    private let categories = ["전기/램프", "엔진/미션", "하체/바디", "내장/외장", "기타소모품"]
    private let trims = ["준중형/소형", "중형", "대형", "SUV", "화물/트럭/승합", "수소/전기"]
    private let trimToModels: [String: [String]] = [
        "준중형/소형": [ "아반떼MD", "아반떼AD", "아반떼CN7", "I30", "엑센트", "아이오닉", "벨로스터", "캐스퍼" ],
        "중형": [ "NF소나타", "YF소나타", "LF소나타", "DN8소나타", "그랜저TG", "그랜저HG", "그랜저IG", "그랜저GN7", "I40" ],
        "대형": ["제네시스BH", "에쿠스"],
        "SUV": [ "베뉴", "코나OS", "코나SX2", "투싼IX", "투싼TL", "투싼NX4", "싼타페CM", "싼타페DM", "싼타페TM", "싼타페MX5", "맥스크루즈", "베라크루즈", "팰리세이드LX2", "팰리세이드LX3" ],
        "화물/트럭/승합": [ "스타렉스", "그랜드스타렉스", "스타리아", "포터2", "쏠라티", "마이티", "메가트럭", "카운티" ],
        "수소/전기": ["아이오닉5", "아이오닉6", "아이오닉9", "넥쏘FE", "넥쏘NH2"]
    ]
    
    private var filteredModels: [String] {
        if inventoryViewModel.selectedTrims.isEmpty {
            return trimToModels.values.flatMap { $0 }
        } else {
            return inventoryViewModel.selectedTrims
                .flatMap { trimToModels[$0] ?? [] }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 🔍 검색창
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("부품을 검색하세요.", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onSubmit {
                            let term = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !term.isEmpty else { return }
                            Task {
//                                await inventoryViewModel.searchByName(name: searchText, reset: true)
                                await inventoryViewModel.searchByName(name: term, reset: true)
                            }
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            inventoryViewModel.isSearching = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing,3)
                    }
                }
                .padding()
                .background(Color(.white))
                .cornerRadius(9999)
                .overlay(
                    RoundedRectangle(cornerRadius: 9999)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .padding(.horizontal)
                .padding(.vertical)
                
                // 필터 및 초기화 버튼
                HStack(spacing: 10) {
                    FilterMenu(
                        title: "카테고리",
                        items: categories,
                        selectedItems: inventoryViewModel.selectedCategories,
                        onTap: { inventoryViewModel.toggleCategory($0) }
                    )
                        
                    FilterMenu(
                        title: "분류",
                        items: trims,
                        selectedItems: inventoryViewModel.selectedTrims,
                        onTap: { inventoryViewModel.toggleTrim($0) }
                    )
                        
                    FilterMenu(
                        title: "모델",
                        items: filteredModels,
                        selectedItems: inventoryViewModel.selectedModels,
                        onTap: { inventoryViewModel.toggleModel($0) }
                    )
                        
                    // 🔄 초기화 버튼
                    Button(action: {
                        inventoryViewModel.resetFilters(with: searchText)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.counterclockwise")
                            Text("초기화")
                        }
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.blue)
                        .padding(.trailing, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                     
                }
                .padding(.horizontal)
                .padding(.bottom, 16)

                // 📋 재고 리스트
                ScrollView {
                    LazyVStack(spacing: 10) {

                        ForEach(
                            inventoryViewModel.isSearching
                            ? inventoryViewModel.filteredSearchResults // 검색 + 필터링
                            : inventoryViewModel.inventoryItems
                        ) { item in
                            InventoryCardView(item: item)
                                .padding(.horizontal)
                                .onAppear {
                                    Task {
                                        if inventoryViewModel.isSearching {
                                            if item.id == inventoryViewModel.filteredSearchResults.last?.id,
                                               inventoryViewModel.searchHasMore {
                                                await inventoryViewModel.loadMore(searchText: searchText)
                                            }
                                        } else {
                                            if item.id == inventoryViewModel.inventoryItems.last?.id,
                                               inventoryViewModel.hasMore {
                                                await inventoryViewModel.loadMore(searchText: searchText)
                                            }
                                        }
                                    }
                                }
                        }

                        if inventoryViewModel.isLoading {
                              ProgressView()
                                  .padding(.vertical)
                          }
                    }
                }
            }
            .background(Color.Light)
            .navigationTitle("재고 조회")
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
                await inventoryViewModel.loadInventoryList(reset: true)
            }
        }
    }
}

// 필터 버튼 공용 컴포넌트
struct FilterMenu: View {
    let title: String
    let items: [String]
    let selectedItems: [String]
    let onTap: (String) -> Void
    
    var displayTitle: String {
        if selectedItems.isEmpty {
            return title
        } else if selectedItems.count == 1 {
            return selectedItems.first ?? title
        } else {
            return "\(title) (\(selectedItems.count))"
        }
    }
    
    var isActive: Bool { !selectedItems.isEmpty }
    
    var truncatedTitle: String {
        // 글자 6자까지만 표시, 이후 "..." 처리
        if displayTitle.count > 8 {
            let prefix = displayTitle.prefix(8)
            return "\(prefix)…"
        }
        return displayTitle
    }
    
    var body: some View {
        Menu {
            ForEach(items, id: \.self) { item in
                Button {
                    onTap(item)
                } label: {
                    HStack {
                        Text(item)
                        if selectedItems.contains(item) {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "chevron.down")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(isActive ? .blue : .gray)
                
                Text(truncatedTitle)
                    .font(.system(size: 13))
                    .foregroundColor(isActive ? .blue : .black)
                    .lineLimit(1)
                    .truncationMode(.tail) // 안전하게 "..." 처리
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10) // 높이 늘림
            .background(
                isActive ? Color.blue.opacity(0.2) : Color(.systemGray6)
            )
            .cornerRadius(8)
        }
    }
}
