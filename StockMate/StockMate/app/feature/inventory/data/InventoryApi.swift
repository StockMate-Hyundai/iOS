//
//  InventoryApi.swift
//  StockMate
//
//  Created by Admin on 10/15/25.
//


import Foundation
import Alamofire

struct InventoryResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: InventoryPageData?
}

struct InventoryPageData: Decodable {
    let content: [InventoryItem]
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
}

struct InventoryItem: Decodable, Identifiable {
    let id: Int
    let name: String
    let price: Int
    let image: String
    let trim: String
    let model: String
    let category: Int
    let korName: String
    let engName: String
    let categoryName: String
    let stock: Int                  // 본사 재고
    let amount: Int                 // 지점별 재고
    let limitAmount: Int            // 지점별 최소 수량
    let isLack: Bool
}

enum InventoryApi {
    static func getInventoryList(
        page: Int,
        size: Int,
        categoryNames: [String],
        trims: [String],
        models: [String]
    ) -> DataRequest {
        var url = ApiClient.baseURL + "api/v1/store/search?page=\(page)&size=\(size)"
        
        for c in categoryNames {
            url += "&categoryName=\(c.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        for t in trims {
            url += "&trim=\(t.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        for m in models {
            url += "&model=\(m.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }

        return ApiClient.shared.request(url, method: .get)
    }
}
