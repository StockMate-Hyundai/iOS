//
//  InventorySearchView.swift
//  StockMate
//
//  Created by Admin on 10/15/25.
//


import SwiftUI

struct InventorySearchView: View {
    @StateObject private var inventoryViewModel = InventoryViewModel()
    @State private var searchText = ""
    
    private let categories = ["전기/램프", "엔진/미션", "하체/바디", "내장/외장", "기타소모품"]
    private let trims = ["준중형/소형", "중형", "대형", "SUV", "화물/트럭/승합", "수소/전기"]
    
    private let trimToModels: [String: [String]] = [
        "준중형/소형": ["아반떼MD", "아반떼AD", "아반떼CN7", "I30", "엑센트", "아이오닉", "벨로스터", "캐스퍼"],
        "중형": ["NF소나타", "YF소나타", "LF소나타", "DN8소나타", "그랜저TG", "그랜저HG", "그랜저IG", "그랜저GN7", "I40"],
        "대형": ["제네시스BH", "에쿠스"],
        "SUV": ["베뉴", "코나OS", "코나SX2", "투싼IX", "투싼TL", "투싼NX4", "싼타페CM", "싼타페DM", "싼타페TM", "싼타페MX5", "맥스크루즈", "베라크루즈", "팰리세이드LX2", "팰리세이드LX3"],
        "화물/트럭/승합": ["스타렉스", "그랜드스타렉스", "스타리아", "포터2", "쏠라티", "마이티", "메가트럭", "카운티"],
        "수소/전기자동차": ["아이오닉5", "아이오닉6", "아이오닉9", "넥쏘FE", "넥쏘NH2"]
    ]
    
    private var filteredModels: [String] {
        if inventoryViewModel.selectedTrims.isEmpty {
            return trimToModels.values.flatMap { $0 }
        } else {
            return inventoryViewModel.selectedTrims.flatMap { trimToModels[$0] ?? [] }
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
                }
                .padding()
                .background(Color(.white))
                .cornerRadius(9999)
                .padding(.horizontal)
                .padding(.vertical)
                
                // 🔽 필터 버튼
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        FilterMenu(
                            title: "카테고리",
                            items: categories,
                            selected: { inventoryViewModel.selectedCategories.contains($0) },
                            onTap: { inventoryViewModel.toggleCategory($0) }
                        )
                        FilterMenu(
                            title: "분류",
                            items: trims,
                            selected: { inventoryViewModel.selectedTrims.contains($0) },
                            onTap: { inventoryViewModel.toggleTrim($0) }
                        )
                        FilterMenu(
                            title: "모델",
                            items: filteredModels,
                            selected: { inventoryViewModel.selectedModels.contains($0) },
                            onTap: { inventoryViewModel.toggleModel($0) }
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top, 2)
                    .padding(.bottom, 4)
                }
                
                // 📋 재고 리스트
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(inventoryViewModel.inventoryItems) { item in
                            InventoryCard(item: item)
                                .padding(.horizontal)
                                .onAppear {
                                    if item.id == inventoryViewModel.inventoryItems.last?.id,
                                       inventoryViewModel.hasMore {
                                        Task {
                                            await inventoryViewModel.loadInventoryList()
                                        }
                                    }
                                }
                        }
                        
                        if inventoryViewModel.isLoading && inventoryViewModel.hasMore {
                            ProgressView()
                                .padding(.vertical)
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .background(Color.Light)
            .navigationTitle("재고 조회")
            .task {
                await inventoryViewModel.loadInventoryList(reset: true)
            }
        }
    }
}

// ✅ 재고 카드 (UI 스타일 적용)
struct InventoryCard: View {
    let item: InventoryItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(item.categoryName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.black)
            
            Divider()
                .frame(height: 0.2)
                .background(Color.textGray2)
            
            HStack(alignment: .center, spacing: 12) {
                AsyncImage(url: URL(string: item.image)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 64, height: 64)
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(item.korName)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                            .lineLimit(2)
                        Spacer()
                    }
                    .padding(.top, 2)
                    
                    Text("\(item.trim)/\(item.model)")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.gray)

                   

                }
                .frame(height: 60, alignment: .top)

                VStack (alignment: .center, spacing: 6) {
                    if item.isLack {
                        Text("수량 부족")
                            .font(.system(size: 13, weight: .regular))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.DangerBg)
                            .foregroundColor(.Danger)
                            .cornerRadius(12)
                    } else {
                            Text("수량 여유")
                                .font(.system(size: 13, weight: .regular))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.StatusGreenBg)
                                .foregroundColor(.StatusGreen)
                                .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading){
                        Text("현재수량: \(item.amount)개")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.textGray1)
                        
                        Text("최소수량: \(item.limitAmount)개")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.textGray1)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 4)
    }
}

// ✅ 필터 버튼 공용 컴포넌트
struct FilterMenu: View {
    let title: String
    let items: [String]
    let selected: (String) -> Bool
    let onTap: (String) -> Void
    
    var body: some View {
        Menu {
            ForEach(items, id: \.self) { item in
                Button {
                    onTap(item)
                } label: {
                    HStack {
                        Text(item)
                        if selected(item) {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
}
