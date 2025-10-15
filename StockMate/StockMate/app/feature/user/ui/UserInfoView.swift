//
//  UserInfoView.swift
//  StockMate
//
//  Created by Admin on 10/14/25.
//

import SwiftUI

struct UserInfoView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        VStack(spacing: 12) {
            if let info = viewModel.userInfo {
                Text("이메일: \(info.email)")
                Text("가게명: \(info.storeName)")
                Text("주소: \(info.address)")
                Text("사업자번호: \(info.businessNumber)")
                Text("권한: \(info.role)")
            } else if !viewModel.message.isEmpty {
                Text(viewModel.message).foregroundColor(.red)
            } else {
                ProgressView("유저 정보 불러오는 중...")
            }
        }
        .padding()
        .onAppear {
            Task {
                await viewModel.loadUserInfo()
            }
        }
    }
}
