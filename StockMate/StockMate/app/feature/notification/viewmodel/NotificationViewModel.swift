//
//  NotificationViewModel.swift
//  StockMate
//
//  Created by Admin on 11/7/25.
//

import Foundation

@MainActor
final class NotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = []
    @Published var unreadCount: Int = 0   // 🔴 추가
    @Published var isLoading = false
    
    private let repository: NotificationRepositoryProtocol = NotificationRepositoryImpl()
    
    // 전체 알림 조회
    func fetchNotifications() async {
        isLoading = true
        defer { isLoading = false }
        
        let result = await repository.getAllNotifications()
        switch result {
        case .success(let response):
              notifications = (response.data ?? []).sorted { $0.createdAt > $1.createdAt }
//            notifications = response.data!.sorted { $0.createdAt > $1.createdAt }
        case .failure(let error):
            print("❌ 알림 조회 실패:", error.localizedDescription)
        }
    }
    
    // 🔴 읽지 않은 개수 조회
    func fetchUnreadCount() async {
        let result = await repository.getUnreadCount()
        switch result {
        case .success(let response):
            unreadCount = response.data ?? 0
        case .failure(let error):
            print("❌ 읽지 않은 개수 조회 실패:", error.localizedDescription)
        }
    }
    
    // 개별 알림 읽음 처리
    func markAsRead(_ id: Int) async {
        let result = await repository.markAsRead(notificationId: id)
        switch result {
        case .success:
            if let index = notifications.firstIndex(where: { $0.id == id }) {
                notifications[index] = NotificationItem(
                    id: notifications[index].id,
                    orderId: notifications[index].orderId,
                    orderNumber: notifications[index].orderNumber,
                    message: notifications[index].message,
                    createdAt: notifications[index].createdAt,
                    read: true
                )
            }
            unreadCount = max(0, unreadCount - 1) // 🔴 카운트 즉시 반영
        case .failure(let error):
            print("❌ 알림 읽음 처리 실패:", error.localizedDescription)
        }
    }
    
    // 전체 읽음 처리
    func markAllAsRead() async {
        let result = await repository.markAllAsRead()
        switch result {
        case .success:
            for i in 0..<notifications.count {
                notifications[i] = NotificationItem(
                    id: notifications[i].id,
                    orderId: notifications[i].orderId,
                    orderNumber: notifications[i].orderNumber,
                    message: notifications[i].message,
                    createdAt: notifications[i].createdAt,
                    read: true
                )
            }
            unreadCount = 0 // 🔴 전체 읽음 시 0으로 초기화
        case .failure(let error):
            print("❌ 전체 읽음 실패:", error.localizedDescription)
        }
    }
}
