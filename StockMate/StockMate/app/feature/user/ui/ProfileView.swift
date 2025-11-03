//
//  ProfileView().swift
//  StockMate
//
//  Created by Admin on 10/21/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var userViewModel = UserViewModel()
     
     var body: some View {
//         NavigationStack {
             VStack(alignment: .leading, spacing: 24) {
                 
                 // MARK: - Profile Header
                 HStack(spacing: 16) {
                     ProfileCircleView(name: userViewModel.userInfo?.owner ?? "사용자", size: 50)
                     
                     VStack(alignment: .leading, spacing: 4) {
                         HStack {
                             Image("location")
                                 .foregroundColor(.gray)
                             Text(userViewModel.userInfo?.storeName ?? "가게명 없음")
                                 .foregroundColor(.gray)
                                 .font(.subheadline)
                         }
                         Text(userViewModel.userInfo?.owner ?? "이름 없음")
                             .font(.title3.bold())
                             .foregroundColor(Color(hex: "#2B3A1A"))
                     }
                     
                     Spacer()
                 }
                 .padding(.horizontal)
                 .padding(.top, 32)
                 
                 // MARK: - General Section
                 VStack(alignment: .leading, spacing: 12) {
                     VStack(spacing: 10) {
                         SettingRow(icon: "user", title: "프로필 수정")
                         SettingRow(icon: "lock", title: "비밀번호 변경")
                         SettingRow(icon: "notification", title: "알림")
                         SettingNavigationRow(icon: "receipt", title: "예치금 히스토리", destination: DepositHistoryView())
//                         SettingRow(icon: "credit", title: "예치금 히스토리")
                         SettingNavigationRow(icon: "bag", title: "주문 내역", destination: OrderListView())
                         SettingRow(icon: "logout", title: "로그아웃")
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
//         }
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
