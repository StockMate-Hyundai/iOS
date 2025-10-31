//
//  OutgoingScanView.swift
//  StockMate
//
//  Created by Admin on 10/31/25.
//


import SwiftUI

struct OutgoingScanView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var scannedCode: String? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""

    @StateObject private var partViewModel = PartViewModel() // ✅ ViewModel 추가

    var body: some View {
        ZStack {
            // ✅ 카메라 미리보기 (QR 스캐너)
            QRScannerView(scannedCode: $scannedCode)
                .ignoresSafeArea()

            // ✅ 스캔 가이드 및 UI 오버레이
            VStack {
                Text("사용할 부품의 QR을 스캔해주세요")
                    .font(.headline)
                    .padding(.top, 60)
                    .foregroundColor(.white)
                    .shadow(radius: 2)

                Spacer()

                // 📷 스캔 박스
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.clear)
                        .frame(width: 250, height: 250)

                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.green, lineWidth: 3)
                        .frame(width: 220, height: 220)
                }
                .padding(.bottom, 180)

                Spacer()

                // 📦 직접 입력 버튼
                Button(action: {
                    dismiss()
                }) {
                    Text("직접 입력 하기")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 2)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }

            // ✅ 로딩 인디케이터
            if partViewModel.isLoading {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView("부품 사용 처리 중...")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
            }
        }
        // ✅ 알림창
        .alert("부품 사용 결과", isPresented: $showAlert) {
            Button("확인") {
                dismiss()
            }
        } message: {
            Text(alertMessage)
        }
        // ✅ QR 스캔 이벤트 발생 시
        .onChange(of: scannedCode) { newValue in
            guard let code = newValue, !code.isEmpty else { return }
            Task {
                await handleScannedCode(code)
            }
        }
        .navigationTitle("부품 사용 처리")
        .navigationBarTitleDisplayMode(.inline)
    }

    // ✅ 스캔된 코드로 출고 API 호출
    private func handleScannedCode(_ code: String) async {
        await MainActor.run {
            partViewModel.isLoading = true
        }

        let request = [ReleaseItemRequest(partCode: code, quantity: 1)] // 기본 1개로 설정
        let result = await partViewModel.releaseParts(items: request)

        await MainActor.run {
            partViewModel.isLoading = false
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

#Preview {
    NavigationStack {
        OutgoingScanView()
    }
}
