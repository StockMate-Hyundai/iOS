//
//  UserProfileView.swift
//  StockMate
//
//  Created by Admin on 11/5/25.
//

import SwiftUI

struct UserProfileView: View {
    @StateObject private var userViewModel = UserViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                Spacer()
                ProfileCircleView(name: userViewModel.userInfo?.owner ?? "사용자", size: 103)
                Spacer()
            }
            .padding(.vertical, 32)
            
            VStack(spacing: 9) {
                ProfileFieldView(label: "대표자", value: userViewModel.userInfo?.owner ?? "이름 없음")
                ProfileFieldView(label: "이메일", value: userViewModel.userInfo?.email ?? "이메일 없음")
                ProfileFieldView(label: "지점", value: userViewModel.userInfo?.storeName ?? "지점명 없음")
                ProfileFieldView(label: "주소", value: userViewModel.userInfo?.address ?? "주소 없음")
                ProfileFieldView(label: "사업자등록번호", value: userViewModel.userInfo?.businessNumber ?? "사업자등록번호 없음")
                
                Spacer()
               
            }
            .padding(3)
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .navigationTitle("프로필 확인")
        .background(Color.Light)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task { await userViewModel.loadUserInfo() }
        }
    }
}

#Preview {
    UserProfileView()
}
