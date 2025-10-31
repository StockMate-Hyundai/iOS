//
//  PartRepositoryProtocol.swift
//  StockMate
//
//  Created by Admin on 10/31/25.
//

import Foundation

protocol PartRepositoryProtocol {
    func releaseParts(items: [ReleaseItemRequest]) async -> AppResult<ApiResponse<String>>
}
