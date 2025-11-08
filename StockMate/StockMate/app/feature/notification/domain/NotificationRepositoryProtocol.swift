//
//  NotificationRepositoryProtocol.swift
//  StockMate
//
//  Created by Admin on 11/7/25.
//

import SwiftUI
import Alamofire


protocol NotificationRepositoryProtocol {
    // 1️⃣ 전체 알림 조회
    func getAllNotifications() async -> AppResult<ApiResponse<[NotificationItem]>>
    
    // 2️⃣ 읽지 않은 알림 개수 조회
    func getUnreadCount() async -> AppResult<ApiResponse<Int>>
    
    // 3️⃣ 읽지 않은 알림 조회
    func getUnreadNotifications() async -> AppResult<ApiResponse<[NotificationItem]>>
    
    // 4️⃣ 전체 알림 읽음 처리
    func markAllAsRead() async -> AppResult<ApiResponse<String>>
    
    // 5️⃣ 개별 알림 읽음 처리
    func markAsRead(notificationId: Int) async -> AppResult<ApiResponse<String>>
}
