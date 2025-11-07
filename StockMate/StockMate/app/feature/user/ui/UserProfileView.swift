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
                Text("대표자")
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .foregroundColor(Color.black)
                
                HStack {
                    Text(userViewModel.userInfo?.owner ?? "이름 없음")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                .cornerRadius(12)
                .overlay(
                   RoundedRectangle(cornerRadius: 12)
                       .stroke(Color.GrayMordern300, lineWidth: 1)
                )
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                
                Text("이메일")
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .foregroundColor(Color.black)
                
                HStack {
                    Text(userViewModel.userInfo?.email ?? "이메일 없음")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                .cornerRadius(12)
                .overlay(
                   RoundedRectangle(cornerRadius: 12)
                       .stroke(Color.GrayMordern300, lineWidth: 1)
                )
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                
                Text("지점")
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .foregroundColor(Color.black)
                
                HStack {
                    Text(userViewModel.userInfo?.storeName ?? "지점명 없음")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                .cornerRadius(12)
                .overlay(
                   RoundedRectangle(cornerRadius: 12)
                       .stroke(Color.GrayMordern300, lineWidth: 1)
                )
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                
                Text("주소")
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .foregroundColor(Color.black)
                
                HStack {
                    Text(userViewModel.userInfo?.address ?? "주소 없음")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                .cornerRadius(12)
                .overlay(
                   RoundedRectangle(cornerRadius: 12)
                       .stroke(Color.GrayMordern300, lineWidth: 1)
                )
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                
                Text("사업자등록번호")
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                    .foregroundColor(Color.black)
                
                HStack {
                    Text(userViewModel.userInfo?.businessNumber ?? "사업자등록번호 없음")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                .cornerRadius(12)
                .overlay(
                   RoundedRectangle(cornerRadius: 12)
                       .stroke(Color.GrayMordern300, lineWidth: 1)
                )
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                
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
