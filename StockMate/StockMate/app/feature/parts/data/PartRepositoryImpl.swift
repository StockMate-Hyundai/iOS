//
//  PartRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 10/31/25.
//

import Foundation
import Alamofire

final class PartRepositoryImpl: PartRepositoryProtocol {
    // 부품 출고 요청
    func releaseParts(items: [ReleaseItemRequest]) async -> AppResult<ApiResponse<String>> {
        let dataReq = PartApi.releaseParts(items: items)
        return await safeApi(dataReq, decodeTo: ApiResponse<String>.self)
    }
    
    // 부품 상세 정보 조회
    func fetchPartDetail(partIds: [Int]) async -> AppResult<ApiResponse<[PartDetailResponse]>> {
        let dataReq = PartApi.fetchPartDetail(partIds: partIds)
        return await safeApi(dataReq, decodeTo: ApiResponse<[PartDetailResponse]>.self)
    }

}
