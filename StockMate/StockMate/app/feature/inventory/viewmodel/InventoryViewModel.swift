//
//  InventoryViewModel.swift
//  StockMate
//
//  Created by Admin on 10/15/25.
//

import SwiftUI

@MainActor
final class InventoryViewModel: ObservableObject {
    @Published var inventoryItems: [InventoryItem] = []
    @Published var message: String = ""
    @Published var shouldGoToLogin: Bool = false

    @Published var selectedCategories: [String] = []
    @Published var selectedTrims: [String] = []
    @Published var selectedModels: [String] = []

    @Published var currentPage = 0
    @Published var isLoading = false
    @Published var hasMore = true
    
    @Published var underLimitItems: [InventoryItem] = []
    @Published var underLimitPage = 0
    @Published var underLimitHasMore = true

    private let repo: InventoryRepositoryProtocol

    init(repo: InventoryRepositoryProtocol = InventoryRepositoryImpl()) {
        self.repo = repo
    }

    // 재고 조회
    func loadInventoryList(
        reset: Bool = false,
        size: Int = 20
    ) async {
        guard !isLoading else { return }
        isLoading = true

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

    // MARK: - Filter toggle
    func toggleCategory(_ name: String) {
        if selectedCategories.contains(name) {
            selectedCategories.removeAll { $0 == name }
        } else {
            selectedCategories.append(name)
        }
        Task { await resetAndLoad() }
    }

    func toggleTrim(_ trim: String) {
        if selectedTrims.contains(trim) {
            selectedTrims.removeAll { $0 == trim }
        } else {
            selectedTrims.append(trim)
        }
        Task { await resetAndLoad() }
    }

    func toggleModel(_ model: String) {
        if selectedModels.contains(model) {
            selectedModels.removeAll { $0 == model }
        } else {
            selectedModels.append(model)
        }
        Task { await resetAndLoad() }
    }
    
    // 부족 재고 조회
//     func loadUnderLimitList(categoryName: String? = nil) async {
//         let result = await repo.getUnderLimitList(
//             categoryName: categoryName,
//             page: 0,
//             size: 10
//         )
//
//         switch result {
//         case .success(let apiResp):
//             if let data = apiResp.data {
//                 underLimitItems = data.content
//             } else {
//                 message = apiResp.message
//             }
//         case .failure(let err):
//             message = err.message
//             if err.code == 401 || err.code == 403 {
//                 shouldGoToLogin = true
//             }
//         }
//     }
    func loadUnderLimitList(reset: Bool = false, size: Int = 10) async {
        guard !isLoading, underLimitHasMore else { return }
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
    
}
