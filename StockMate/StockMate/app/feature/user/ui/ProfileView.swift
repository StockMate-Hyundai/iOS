//
//  ProfileView().swift
//  StockMate
//
//  Created by Admin on 10/21/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var userViewModel = UserViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel  // 전역 Auth 상태 참조
    @State private var showLogoutModal = false           // 로그아웃 모달 상태
     
     var body: some View {
         ZStack{
             VStack(alignment: .leading, spacing: 24) {
                 
                 // MARK: - Profile Header
                 HStack(spacing: 16) {
                     ProfileCircleView(name: userViewModel.userInfo?.owner ?? "사용자", size: 50)
                     
                     VStack(alignment: .leading, spacing: 4) {
                         Text(userViewModel.userInfo?.owner ?? "이름 없음")
                             .font(.title3.bold())
                             .foregroundColor(Color(hex: "#2B3A1A"))
                         
                         Text(userViewModel.userInfo?.email ?? "이메일 없음")
                             .foregroundColor(.gray)
                             .font(.subheadline)
                     }
                     
                     Spacer()
                 }
                 .padding(.horizontal)
                 .padding(.top, 32)
                 
                 // MARK: - General Section
                 VStack(alignment: .leading, spacing: 12) {
                     VStack(spacing: 10) {
                         SettingNavigationRow(icon: "user", title: "프로필 확인", destination: UserProfileView())
                         SettingNavigationRow(icon: "notification", title: "알림", destination: NotificationListView())
                         SettingNavigationRow(icon: "receipt", title: "예치금 히스토리", destination: TransactionTypeListView())
                         SettingNavigationRow(icon: "bag", title: "주문 내역", destination: OrderListView())
                         // 로그아웃 버튼
                         Button {
                             showLogoutModal = true
                         } label: {
                             SettingRow(icon: "logout", title: "로그아웃")
                         }
                     }
                     .padding(3)
                     .background(Color.Light)
                     .cornerRadius(12)
                     .padding(.horizontal)
                 }
                 
                 Spacer()
             }
             .background(Color.Light)
             .navigationBarTitleDisplayMode(.inline)
             .onAppear {
                 Task { await userViewModel.loadUserInfo() }
             }
             
             // AlertModal (ZStack 위에 오버레이로 표시)
             if showLogoutModal {
                 Color.black.opacity(0.3)
                     .ignoresSafeArea()
                     .transition(.opacity)
                 
                 AlertModal(
                    title: "로그아웃",
                    message: "정말 로그아웃 하시겠습니까?",
                    primaryButtonTitle: "로그아웃",
                    primaryAction: {
                        authViewModel.logout()
                        showLogoutModal = false
                    },
                    secondaryButtonTitle: "취소",
                    secondaryAction: {
                        showLogoutModal = false
                    },
                    buttonLayout: .horizontal
                 )
                 .transition(.scale)
                 .zIndex(1)
             }
             
         }
         .animation(.easeInOut, value: showLogoutModal)
     }
 }

 // MARK: - SettingRow (동일)
struct SettingRow: View {
    var icon: String
    var title: String
    var iconColor: Color = .black
    var textColor: Color = .primary

    var body: some View {
        HStack {
            Image(icon)
                .font(.system(size: 18))
                .foregroundColor(iconColor)
                .frame(width: 24)

            Text(title)
                .font(.system(size: 16))
                .foregroundColor(textColor)

            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.Light))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray4), lineWidth: 1))
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
    }
}

struct SettingNavigationRow<Destination: View>: View {
    var icon: String
    var title: String
    var iconColor: Color = .black
    var textColor: Color = .primary
    var destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(icon)
                    .font(.system(size: 18))
                    .foregroundColor(iconColor)
                    .frame(width: 24)

                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(textColor)

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.Light))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray4), lineWidth: 1))
            .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
        }
    }
}


 #Preview {
     ProfileView()
 }
