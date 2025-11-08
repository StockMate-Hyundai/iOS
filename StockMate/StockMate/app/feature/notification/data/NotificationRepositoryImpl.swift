//
//  NotificationRepositoryImpl.swift
//  StockMate
//
//  Created by Admin on 11/7/25.
//

import SwiftUI
import Alamofire

final class NotificationRepositoryImpl: NotificationRepositoryProtocol {
    
    func getAllNotifications() async -> AppResult<ApiResponse<[NotificationItem]>> {
        let request = NotificationApi.getAllNotifications()
        return await safeApi(request, decodeTo: ApiResponse<[NotificationItem]>.self)
    }
    
    func getUnreadCount() async -> AppResult<ApiResponse<Int>> {
        let request = NotificationApi.getUnreadCount()
        return await safeApi(request, decodeTo: ApiResponse<Int>.self)
    }
    
    func getUnreadNotifications() async -> AppResult<ApiResponse<[NotificationItem]>> {
        let request = NotificationApi.getUnreadNotifications()
        return await safeApi(request, decodeTo: ApiResponse<[NotificationItem]>.self)
    }
    
    func markAllAsRead() async -> AppResult<ApiResponse<String>> {
        let request = NotificationApi.markAllAsRead()
        return await safeApi(request, decodeTo: ApiResponse<String>.self)
    }
    
    func markAsRead(notificationId: Int) async -> AppResult<ApiResponse<String>> {
        let request = NotificationApi.markAsRead(notificationId: notificationId)
        return await safeApi(request, decodeTo: ApiResponse<String>.self)
    }
}
