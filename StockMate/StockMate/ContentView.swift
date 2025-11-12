//
//  ContentView.swift
//  StockMate
//
//  Created by Admin on 10/5/25.
//

import SwiftUI

struct ContentView: View {
    @State private var address: String = "주소를 선택하세요"
    @State private var showWebView = false

    var body: some View {
        VStack(spacing: 20) {
            Text(address)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()

            Button("주소 검색") {
                showWebView.toggle()
            }
            .font(.headline)
            .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $showWebView) {
            KakaoZipCodeView(address: $address)
        }
    }
}


#Preview {
    ContentView()
}
