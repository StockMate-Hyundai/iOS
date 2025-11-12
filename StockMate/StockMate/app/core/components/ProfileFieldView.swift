//
//  ProfileFieldView.swift
//  StockMate
//
//  Created by Admin on 11/7/25.
//

import SwiftUI

struct ProfileFieldView: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 9) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .foregroundColor(Color.black)
            
            HStack {
                Text(value)
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
        }
    }
}
