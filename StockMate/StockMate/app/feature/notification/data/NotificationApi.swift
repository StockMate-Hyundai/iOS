//
//  NotificationApi.swift
//  StockMate
//
//  Created by Admin on 11/7/25.
//

import Foundation
import Alamofire

// MARK: - 알림 데이터 구조
struct NotificationItem: Decodable, Identifiable {
    let id: Int
    let orderId: Int
    let orderNumber: String
    let message: String
    let createdAt: String
    let read: Bool
}

// MARK: - 알림 관련 API
enum NotificationApi {
    
    // MARK: 알림 전체 조회
    static func getAllNotifications() -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/store/notifications/"
        return ApiClient.shared.request(url, method: .get)
    }
    
    // MARK: 읽지 않은 알림 개수 조회
    static func getUnreadCount() -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/store/notifications/unread/count"
        return ApiClient.shared.request(url, method: .get)
    }
    
    // MARK: 읽지 않은 알림 목록 조회
    static func getUnreadNotifications() -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/store/notifications/unread"
        return ApiClient.shared.request(url, method: .get)
    }
    
    // MARK: 전체 알림 읽음 처리
    static func markAllAsRead() -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/store/notifications/read-all"
        return ApiClient.shared.request(url, method: .patch)
    }
    
    // MARK: 개별 알림 읽음 처리
    static func markAsRead(notificationId: Int) -> DataRequest {
        let url = ApiClient.baseURL + "api/v1/order/store/notifications/read?notificationId=\(notificationId)"
        return ApiClient.shared.request(url, method: .patch)
    }
}
