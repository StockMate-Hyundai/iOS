//
//  IncomingScanView.swift
//  StockMate
//
//  Created by Admin on 10/13/25.
//

import SwiftUI

struct IncomingScanView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var scannedCode: String? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @StateObject private var orderViewModel = OrderViewModel() // 뷰모델 추가

    var body: some View {
        ZStack {
            // 1. 카메라 화면 (QR 스캐너)
            QRScannerView(scannedCode: $scannedCode)
                .ignoresSafeArea()

            // 2. 스캔 영역 가이드 박스
            VStack {
                Text("입고 부품의 QR을 스캔해주세요")
                    .font(.headline)
                    .padding(.top, 60)
                    .foregroundColor(.white)
                    .shadow(radius: 2)

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.clear)
                        .frame(width: 250, height: 250)

                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 3)
                        .frame(width: 220, height: 220)
                }
                .padding(.bottom, 180)

                Spacer()
            }

            // 로딩 표시
            if orderViewModel.isLoading {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView("입고 처리 중...")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
            }
        }
        .alert("입고 처리 결과", isPresented: $showAlert) {
            Button("확인") {
                dismiss()
            }
        } message: {
            Text(alertMessage)
        }
        .onChange(of: scannedCode) { newValue in
            guard let code = newValue, !code.isEmpty else { return }
            Task {
                await handleScannedCode(code)
            }
        }
        .navigationTitle("입고 부품 등록")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
    
    private func handleScannedCode(_ code: String) async {
        await MainActor.run {
            orderViewModel.isLoading = true
        }
        
        let result = await orderViewModel.receiveOrder(orderNumber: code)
        await MainActor.run {
            orderViewModel.isLoading = false
            switch result {
            case .success(let message):
                alertMessage = message
            case .failure(let error):
                alertMessage = error.message
            }
            showAlert = true
        }
    }
}
