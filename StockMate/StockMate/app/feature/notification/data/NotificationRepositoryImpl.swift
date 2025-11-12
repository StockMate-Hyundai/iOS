//
//  NotificationRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 11/7/25.
//

import SwiftUI
import Alamofire

// 알림 관련 API 호출을 담당하는 Repository 구현체
final class NotificationRepositoryImpl: NotificationRepositoryProtocol {
    // 전체 알림 목록 조회
    func getAllNotifications() async -> AppResult<ApiResponse<[NotificationItem]>> {
        let request = NotificationApi.getAllNotifications()
        return await safeApi(request, decodeTo: ApiResponse<[NotificationItem]>.self)
    }
    // 읽지 않은 알림 개수 조회
    func getUnreadCount() async -> AppResult<ApiResponse<Int>> {
        let request = NotificationApi.getUnreadCount()
        return await safeApi(request, decodeTo: ApiResponse<Int>.self)
    }
    
    // 읽지 않은 알림 목록 조회
    func getUnreadNotifications() async -> AppResult<ApiResponse<[NotificationItem]>> {
        let request = NotificationApi.getUnreadNotifications()
        return await safeApi(request, decodeTo: ApiResponse<[NotificationItem]>.self)
    }
    
    // 모든 알림을 읽음 처리
    func markAllAsRead() async -> AppResult<ApiResponse<String>> {
        let request = NotificationApi.markAllAsRead()
        return await safeApi(request, decodeTo: ApiResponse<String>.self)
    }
    
    // 특정 알림을 읽음 처리
    func markAsRead(notificationId: Int) async -> AppResult<ApiResponse<String>> {
        let request = NotificationApi.markAsRead(notificationId: notificationId)
        return await safeApi(request, decodeTo: ApiResponse<String>.self)
    }
}
