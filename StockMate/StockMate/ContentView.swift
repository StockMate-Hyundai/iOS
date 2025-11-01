//
//  ContentView.swift
//  StockMate
//
//  Created by Admin on 10/5/25.
//

import SwiftUI

//struct ContentView: View {
//    @State private var showingScanner = false
//    @State private var scannedCode: String? = nil
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                if let code = scannedCode {
//                    Text("스캔 결과:")
//                        .font(.headline)
//                    Text(code)
//                        .font(.body)
//                        .multilineTextAlignment(.center)
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(8)
//                } else {
//                    Text("아직 스캔된 코드가 없습니다.")
//                        .foregroundColor(.secondary)
//                }
//
//                Button("QR 스캔 시작") {
//                    // 카메라 권한 체크는 시스템이 자동으로 권한 알림을 띄우므로
//                    // 필요하면 권한 상태 확인 로직 추가 가능
//                    showingScanner = true
//                }
//                .buttonStyle(.borderedProminent)
//                .padding(.top)
//
//                Spacer()
//            }
//            .padding()
//            .navigationTitle("QR 스캐너 예제")
//            .sheet(isPresented: $showingScanner) {
//                QRScannerView(isPresented: $showingScanner, scannedCode: $scannedCode)
//                    .edgesIgnoringSafeArea(.all)
//            }
//        }
//    }
//}
struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("임시 화면")
        }
        .padding()
        HStack(spacing: 20) {
            Image(systemName: "gearshape")
                .font(.system(size: 40))
                .foregroundColor(.blue)

            Image(systemName: "lightbulb")
                .font(.system(size: 40))
                .foregroundColor(.cyan)
        }
    }
}

#Preview {
    ContentView()
}
