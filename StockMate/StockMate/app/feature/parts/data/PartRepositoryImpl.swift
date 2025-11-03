//
//  PartRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 10/31/25.
//

import Foundation
import Alamofire

final class PartRepositoryImpl: PartRepositoryProtocol {
    func releaseParts(items: [ReleaseItemRequest]) async -> AppResult<ApiResponse<String>> {
        let dataReq = PartApi.releaseParts(items: items)
        return await safeApi(dataReq, decodeTo: ApiResponse<String>.self)
    }
    
    // ✅ 부품 상세 조회 API
    func fetchPartDetail(partId: Int) async -> AppResult<ApiResponse<[PartDetailResponse]>> {
        let dataReq = PartApi.fetchPartDetail(partId: partId)
        return await safeApi(dataReq, decodeTo: ApiResponse<[PartDetailResponse]>.self)
    }
}
