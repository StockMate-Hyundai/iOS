//
//  HistoryViewModel.swift
//  StockMate
//
//  Created by Admin on 11/1/25.
//

import Foundation
import Alamofire

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var histories: [HistoryItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil // ✅ 추가
    @Published var currentPage = 0
    @Published var totalPages = 1

    private let repository: HistoryRepositoryProtocol

    init(repository: HistoryRepositoryProtocol = HistoryRepositoryImpl()) {
        self.repository = repository
    }

    /// ✅ 입출고 히스토리 불러오기
    func fetchInOutHistory(page: Int = 0, size: Int = 20) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        let result = await repository.getInOutHistory(page: page, size: size) // ✅ 오타도 수정됨 (getInout → getInOut)
        switch result {
        case .success(let response):
            if let data = response.data {
                if page == 0 {
                    histories = data.content
                } else {
                    histories.append(contentsOf: data.content)
                }
                currentPage = data.currentPage
                totalPages = data.totalPages
                errorMessage = nil
            } else {
                errorMessage = "데이터가 없습니다."
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
            print("❌ 입출고 히스토리 조회 실패:", error)
        }
    }

    /// ✅ 다음 페이지 로드 (무한 스크롤 등)
    func loadMoreIfNeeded(currentItem item: HistoryItem?) async {
        guard let item = item else { return }
        let thresholdIndex = histories.index(histories.endIndex, offsetBy: -5)
        if histories.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            if currentPage + 1 < totalPages {
                await fetchInOutHistory(page: currentPage + 1)
            }
        }
    }
}
