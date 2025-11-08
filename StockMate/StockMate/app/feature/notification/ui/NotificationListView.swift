//
//  NotificationListView.swift
//  StockMate
//
//  Created by Admin on 11/7/25.
//
import SwiftUI

struct NotificationListView: View {
    @StateObject private var viewModel = NotificationViewModel()
    @State private var selectedOrderId: Int? = nil

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.notifications) { notification in
                        NotificationCardView(item: notification) {
                            Task {
                                await viewModel.markAsRead(notification.id)
                                selectedOrderId = notification.orderId
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.Light)
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("전체 읽음") {
                    Task { await viewModel.markAllAsRead() }
                }
                .foregroundColor(.red)
                .font(.subheadline)
            }
        }
        .navigationDestination(item: $selectedOrderId) { orderId in
            OrderDetailView(orderId: orderId, orderViewModel: OrderViewModel())
        }
        .task {
            await viewModel.fetchNotifications()
        }
    }
}


struct NotificationCardView: View {
    let item: NotificationItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .center, spacing: 14) {
                Image("notiImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.message)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(item.orderNumber)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.gray)
                    Text(formattedDate(item.createdAt))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                // 🔴 안 읽은 알림 표시 점
                 if !item.read {
                     Circle()
                         .fill(Color.red)
                         .frame(width: 7, height: 7)
                         .padding(.trailing)
                 }
              
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
        }
    }
}
