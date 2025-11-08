//
//  NotificationApi.swift
//  StockMate
//
//  Created by Admin on 11/7/25.
//

import Foundation
import Alamofire

struct NotificationItem: Decodable, Identifiable {
    let id: Int
    let orderId: Int
    let orderNumber: String
    let message: String
    let createdAt: String
    let read: Bool
}

enum NotificationApi {
    
    // 1️⃣ 알림 전체 조회
    static func getAllNotifications() -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/store/notifications/"
        return ApiClient.shared.request(url, method: .get)
    }
    
    // 2️⃣ 읽지 않은 알림 개수 조회
    static func getUnreadCount() -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/store/notifications/unread/count"
        return ApiClient.shared.request(url, method: .get)
    }
    
    // 3️⃣ 읽지 않은 알림 조회
    static func getUnreadNotifications() -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/store/notifications/unread"
        return ApiClient.shared.request(url, method: .get)
    }
    
    // 4️⃣ 전체 알림 읽음 처리
    static func markAllAsRead() -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/store/notifications/read-all"
        return ApiClient.shared.request(url, method: .patch)
    }
    
    // 5️⃣ 개별 알림 읽음 처리
    static func markAsRead(notificationId: Int) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/store/notifications/read?notificationId=\(notificationId)"
        return ApiClient.shared.request(url, method: .patch)
    }
}
