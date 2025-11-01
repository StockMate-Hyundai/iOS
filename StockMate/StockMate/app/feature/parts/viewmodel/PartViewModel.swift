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
    
    private let repo: PartRepositoryProtocol
    
    init(repo: PartRepositoryProtocol = PartRepositoryImpl()) {
        self.repo = repo
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