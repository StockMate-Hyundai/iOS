//
//  InventoryViewModel.swift
//  StockMate
//
//  Created by Admin on 10/15/25.
//

import SwiftUI

@MainActor
final class InventoryViewModel: ObservableObject {
    // ===== 기본 상태 =====
    @Published var inventoryItems: [InventoryItem] = []
    @Published var message: String = ""
    @Published var shouldGoToLogin: Bool = false
    
    // ====== 필터 상태 ======
    @Published var selectedCategories: [String] = []
    @Published var selectedTrims: [String] = []
    @Published var selectedModels: [String] = []

    
    // ===== 전체 재고 페이지네이션 =====
    @Published var currentPage = 0
    @Published var hasMore = true
    
    // ====== 부족 재고 페이지네이션 ======
    @Published var underLimitItems: [InventoryItem] = []
    @Published var underLimitPage = 0
    @Published var underLimitHasMore = true
    
    // ====== 검색 관련 ======
    @Published var searchResults: [InventoryItem] = []
    @Published var searchPage = 0
    @Published var searchHasMore = true
    @Published var isSearching = false
   
    // ====== 공통 상태 ======
    @Published var isLoading = false
    
    // ===== 카테고리별 부족 재고 개수 =====
    @Published var lackCounts: [LackCountItem] = []
    
    
    private let repo: InventoryRepositoryProtocol

    init(repo: InventoryRepositoryProtocol = InventoryRepositoryImpl()) {
        self.repo = repo
    }

    // MARK: - 전체 재고 로드
    func loadInventoryList(reset: Bool = false, size: Int = 20) async {
        guard !isLoading else { return }
        isLoading = true
        isSearching = false   // 검색 모드 해제

        if reset {
            currentPage = 0
            inventoryItems.removeAll()
            hasMore = true
        }

        let result = await repo.getInventoryList(
            page: currentPage,
            size: size,
            categoryNames: selectedCategories,
            trims: selectedTrims,
            models: selectedModels
        )

        switch result {
        case .success(let apiResp):
            if let data = apiResp.data {
                if reset {
                    inventoryItems = data.content
                } else {
                    inventoryItems.append(contentsOf: data.content)
                }
                hasMore = currentPage + 1 < data.totalPages
                currentPage += 1
            } else {
                message = apiResp.message
            }
        case .failure(let err):
            message = err.message
            if err.code == 401 || err.code == 403 {
                shouldGoToLogin = true
            }
        }
        isLoading = false
    }
    
    
    func resetAndLoad() async {
        await loadInventoryList(reset: true)
    }
    
    // MARK: - 부족 재고 로드
    func loadUnderLimitList(reset: Bool = false, size: Int = 10) async {
//        guard !isLoading, underLimitHasMore else { return }
        guard !isLoading, (underLimitHasMore || reset) else { return }
        isLoading = true
        
        if reset {
            underLimitPage = 0
            underLimitItems.removeAll()
            underLimitHasMore = true
        }

        // 여기서 under-limit API 호출
        let result = await repo.getUnderLimitList(
            categoryName: selectedCategories.first, // 필터 적용 시 사용
            page: underLimitPage,
            size: size
        )
        
        switch result {
        case .success(let apiResp):
            if let data = apiResp.data {
                if reset {
                    underLimitItems = data.content
                } else {
                    underLimitItems.append(contentsOf: data.content)
                }
                underLimitHasMore = underLimitPage + 1 < data.totalPages
                underLimitPage += 1
            }
        case .failure(let err):
            message = err.message
            if err.code == 401 || err.code == 403 {
                shouldGoToLogin = true
            }
        }
        isLoading = false
    }
    
    // MARK: - 이름 검색
    func searchByName(name: String, reset: Bool = false, size: Int = 20) async {
        guard !isLoading else { return }
        isLoading = true
        isSearching = true

        if reset {
            searchPage = 0
            searchResults.removeAll()
            searchHasMore = true
        }

        let result = await repo.findByName(name: name, page: searchPage, size: size)
        
        switch result {
        case .success(let apiResp):
            if let data = apiResp.data {
                if reset {
                    searchResults = data.content
                } else {
                    searchResults.append(contentsOf: data.content)
                }
                searchHasMore = searchPage + 1 < data.totalPages
                searchPage += 1
            }
        case .failure(let err):
            message = err.message
            if err.code == 401 || err.code == 403 {
                shouldGoToLogin = true
            }
        }

        isLoading = false
    }
    
    // MARK: - 검색 결과에서 로컬 필터링
    var filteredSearchResults: [InventoryItem] {
        searchResults.filter { item in
            // 카테고리 필터
            if !selectedCategories.isEmpty && !selectedCategories.contains(item.categoryName) {
                return false
            }
            // 트림 필터
            if !selectedTrims.isEmpty && !selectedTrims.contains(item.trim) {
                return false
            }
            // 모델 필터
            if !selectedModels.isEmpty && !selectedModels.contains(item.model) {
                return false
            }
            return true
        }
    }
    
    // MARK: - 필터 토글 (검색모드 해제 + 전체 재로드)
    func toggleCategory(_ name: String) {
        if selectedCategories.contains(name) {
            selectedCategories.removeAll { $0 == name }
        } else {
            selectedCategories.append(name)
        }
        // ✅ 검색 중일 때는 로컬 필터링만 다시 계산
         if isSearching {
             objectWillChange.send()
         } else {
             Task { await resetAndLoad() }
         }
        
//        isSearching = false
//        Task { await resetAndLoad() }
    }

    func toggleTrim(_ trim: String) {
        if selectedTrims.contains(trim) {
            selectedTrims.removeAll { $0 == trim }
        } else {
            selectedTrims.append(trim)
        }
        if isSearching {
            objectWillChange.send()
        } else {
            Task { await resetAndLoad() }
        }
//        isSearching = false
//        Task { await resetAndLoad() }
    }

    func toggleModel(_ model: String) {
        if selectedModels.contains(model) {
            selectedModels.removeAll { $0 == model }
        } else {
            selectedModels.append(model)
        }
        if isSearching {
              objectWillChange.send()
          } else {
              Task { await resetAndLoad() }
          }
//        isSearching = false
//        Task { await resetAndLoad() }
    }
    
    // MARK: - 필터 초기화
    func resetFilters(with searchText: String) {
        // 1. 필터 관련 선택 초기화
        selectedCategories.removeAll()
        selectedTrims.removeAll()
        selectedModels.removeAll()
        
        // 2. 검색어가 없을 경우 → 전체 재고 다시
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            isSearching = false
            searchResults.removeAll()
            // searchPage = 0
            Task { await loadInventoryList(reset: true) }
        }
        // 3. 검색어가 있는 경우 → 해당 검색어로 전체 결과 다시 검색
        else {
            isSearching = true
            //searchPage = 0
            searchResults.removeAll()
//            Task { await searchByName(name: searchText, reset: true) }
            Task {
                await searchByName(
                    name: searchText.trimmingCharacters(in: .whitespacesAndNewlines),
                    reset: true
                )
            }
        }
    }
    
    // MARK: - ✅ 무한 스크롤 로드
    func loadMore(searchText: String) async {
        if isSearching {
            guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            await searchByName(name: searchText)
        } else {
            await loadInventoryList()
        }
    }
    
    
    // MARK: - 카테고리별 부족 재고 개수 로드
    func loadLackCountByCategory() async {
        guard !isLoading else { return }
        isLoading = true

        let result = await repo.getLackCountByCategory()

        switch result {
        case .success(let apiResp):
            if let data = apiResp.data {
                lackCounts = data
            } else {
                message = apiResp.message
            }
        case .failure(let err):
            message = err.message
            if err.code == 401 || err.code == 403 {
                shouldGoToLogin = true
            }
        }

        isLoading = false
    }

}
