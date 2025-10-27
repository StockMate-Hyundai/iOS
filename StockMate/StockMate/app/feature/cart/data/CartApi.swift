//
//  CartApi.swift
//  StockMate
//
//  Created by Admin on 10/25/25.
//

import Foundation
import Alamofire

// === Response ===
// 빈 데이터 응답용
struct VoidData: Codable {}

// get/put/post 응답, put,post는 totalPrice가 없음 -> optional
struct CartData: Decodable {
    let cartId: Int
    let memberId: Int
    let items: [CartItem]
    let totalPrice: Int?
}

// put,post는 cartItemId,partId,amount만 필요 -> optional
struct CartItem: Decodable, Identifiable {
    let cartItemId: Int
    let partId: Int
    var amount: Int
    let partName: String?
    let categoryName: String?
    let brand: String?
    let model: String?
    let trim: String?
    let price: Int?
    let stock: Int?

//    var id: Int { cartItemId }
    var id: Int { partId }

}


// === Request === put,post만 요청값이 있음
struct CartUpdateRequest: Encodable {
    let items: [CartUpdateItem]
}

struct CartUpdateItem: Encodable {
    let partId: Int
    let amount: Int
}

enum CartApi {
    // GET - 장바구니 조회
    static func fetchCart() -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/cart"
        return ApiClient.shared.request(url, method: .get)
    }

    // POST - 장바구니 등록 (추가)
    static func addToCart(_ body: CartUpdateRequest) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/cart"
        return ApiClient.shared.request(url,
                                        method: .post,
                                        parameters: body,
                                        encoder: JSONParameterEncoder.default)
    }

    // PUT - 장바구니 수정 (전체 덮어쓰기 형태)
    static func updateCart(_ body: CartUpdateRequest) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/cart"
        return ApiClient.shared.request(url,
                                        method: .put,
                                        parameters: body,
                                        encoder: JSONParameterEncoder.default)
    }

    // DELETE - 장바구니 전체 비우기 (파라미터 없음)
    static func clearCart() -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/cart"
        return ApiClient.shared.request(url, method: .delete)
    }
}
