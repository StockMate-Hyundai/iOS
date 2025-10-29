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
                     Text("General")
                         .font(.system(size: 16, weight: .semibold))
                         .padding(.leading)
                     
                     VStack(spacing: 10) {
                         SettingRow(icon: "person.crop.circle", title: "Edit Profile")
                         SettingRow(icon: "lock.circle", title: "Change Password")
                         SettingRow(icon: "bell", title: "Notifications")
                         SettingRow(icon: "location.circle", title: "배송 현황")
                         
                         SettingNavigationRow(icon: "bag", title: "주문 내역", destination: OrderListView())
                     }
                     .padding(3)
                     .background(Color.Light)
                     .cornerRadius(12)
                     .padding(.horizontal)
                 }
                 
                 // MARK: - Preferences Section
                 VStack(alignment: .leading, spacing: 12) {
                     Text("Preferences")
                         .font(.system(size: 16, weight: .semibold))
                         .padding(.leading)
                     
                     VStack(spacing: 10) {
                         SettingRow(icon: "shield", title: "Legal and Policies")
                         SettingRow(icon: "questionmark.circle", title: "Help & Support")
                         SettingRow(icon: "arrow.right.circle", title: "Logout", iconColor: .red, textColor: .red)
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
            Image(systemName: icon)
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
                Image(systemName: icon)
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
