//
//  PartRepositoryProtocol.swift
//  StockMate
//
//  Created by Admin on 10/31/25.
//

import Foundation

protocol PartRepositoryProtocol {
    // 부품 출고 요청
    func releaseParts(items: [ReleaseItemRequest]) async -> AppResult<ApiResponse<String>>
    
    // 부품 상세 정보 조회
    func fetchPartDetail(partIds: [Int]) async -> AppResult<ApiResponse<[PartDetailResponse]>>
}
