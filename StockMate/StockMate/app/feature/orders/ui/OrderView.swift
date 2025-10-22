//
//  OrderView.swift
//  StockMate
//
//  Created by Admin on 10/14/25.
//

import SwiftUI

struct OrderView: View {
    var body: some View {
        VStack(spacing: 0) {
            // 타이틀
            Text("발주 요청")
                .font(.title2)
                .bold()
                .padding(.top, 13)
                .padding(.leading, 25)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // 🔍 검색창
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                Text("부품을 검색하세요.")
//                TextField("부품을 검색하세요.", text: $searchText)
//                    .textFieldStyle(PlainTextFieldStyle())

            }
            .padding()
            .background(Color(.white))
            .cornerRadius(9999)
            .overlay(
                RoundedRectangle(cornerRadius: 9999)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .padding(.horizontal)
            .padding(.vertical)
        }
    }
}

#Preview {
    OrderView()
}
