//
//  PartViewModel.swift
//  StockMate
//
//  Created by Admin on 10/31/25.
//


import SwiftUI

@MainActor
final class PartViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var message: String = ""
    @Published var shouldGoToLogin = false
    
    
    // ✅ 임시 저장 리스트
    @Published var selectedParts: [PartDetailResponse] = []
    @Published var quantities: [Int: Int] = [:]  // partId별 수량 관리
    
    
    private let repo: PartRepositoryProtocol
    
    init(repo: PartRepositoryProtocol = PartRepositoryImpl()) {
        self.repo = repo
    }
    
    // ✅ 부품 상세 조회 (QR 스캔 후)
    func fetchPartDetail(partId: Int) async {
        isLoading = true
        defer { isLoading = false }

        let result = await repo.fetchPartDetail(partId: partId)
        switch result {
        case .success(let apiResp):
            if let detail = apiResp.data?.first {
                if !selectedParts.contains(where: { $0.id == detail.id }) {
                    selectedParts.append(detail)
                    quantities[detail.id] = 1
                } else {
                    quantities[detail.id, default: 1] += 1
                }
            }
        case .failure(let error):
            message = error.message
        }
    }

    func increaseQuantity(for partId: Int) {
        quantities[partId, default: 1] += 1
    }

    func decreaseQuantity(for partId: Int) {
        quantities[partId] = max(1, (quantities[partId] ?? 1) - 1)
    }

    func removePart(partId: Int) {
        selectedParts.removeAll { $0.id == partId }
        quantities.removeValue(forKey: partId)
    }

    func makeReleasePayload() -> [ReleaseItemRequest] {
        selectedParts.map { part in
            ReleaseItemRequest(partId: part.id, quantity: quantities[part.id] ?? 1)
        }
    }
    
    
    
    func releaseParts(items: [ReleaseItemRequest]) async -> AppResult<String> {
        isLoading = true
        defer { isLoading = false }
        
        let result = await repo.releaseParts(items: items)
        switch result {
        case .success(let apiResp):
            message = apiResp.message
            if let data = apiResp.data {
                return .success(data)
            } else {
                return .failure(AppError(code: apiResp.status, message: apiResp.message, underlying: nil))
            }
        case .failure(let err):
            message = err.message
            if err.code == 401 || err.code == 403 {
                shouldGoToLogin = true
            }
            return .failure(err)
        }
    }
    
    
}
