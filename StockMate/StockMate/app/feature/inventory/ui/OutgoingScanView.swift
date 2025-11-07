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
    
    // 전역 부품 저장소
    @EnvironmentObject var partStore: PartStore
    @StateObject private var partViewModel = PartViewModel() // ✅ ViewModel 추가
    
    @State private var showBottomSheet = false
    
    @State private var scannerRestartTrigger = false

    @State private var partDetail: PartDetail? = nil
    

    var body: some View {
        ZStack {
            // ✅ 카메라 미리보기 (QR 스캐너)
//            QRScannerView(scannedCode: $scannedCode)
//                .ignoresSafeArea()
            QRScannerView(scannedCode: $scannedCode, isActive: !showBottomSheet)
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
                ProgressView("부품 조회 중...") //ProgressView("부품 사용 처리 중...")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
            }
        }
        .alert("알림", isPresented: $showAlert) {
            Button("확인") {}
        } message: {
            Text(alertMessage)
        }
        .onChange(of: scannedCode) { newValue in
            guard let code = newValue, !code.isEmpty else { return }
            Task { await handleScannedCode(code) }
        }
        .sheet(isPresented: $showBottomSheet) {
            UsedPartListSheetView(
                onUseParts: {
                    Task {
                        // ✅ payload 생성
                        let payload = partStore.parts.map {
                            ReleaseItemRequest(partId: $0.id, quantity: $0.quantity)
                        }

                        // ✅ API 호출
                        let result = await partViewModel.releaseParts(items: payload)

                        await MainActor.run {
                            switch result {
                            case .success(let message):
                                alertMessage = message
                                showAlert = true

                                // ✅ 성공 시: 전역 부품 초기화 + 바텀시트 닫기 + 화면 복귀
                                partStore.clear()
                                showBottomSheet = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    dismiss()
                                }

                            case .failure(let error):
                                alertMessage = error.message
                                showAlert = true
                            }
                        }
                    }
                },
                onRescan: {
                    // ✅ 다시 스캔 버튼 눌렀을 때
                    showBottomSheet = false
                    resetScanState() // QR 다시 활성화
                }
            )
            .presentationDetents([.fraction(0.80)]) // 시트 높이 80%
            .presentationCornerRadius(28)           // ✅ 모서리 곡률
            .environmentObject(partStore)
        }
           .navigationTitle("부품 사용 처리")
           .navigationBarTitleDisplayMode(.inline)
    }
    
    // ✅ 스캔된 코드로 부품 상세 조회만 수행 (출고 X)
    private func handleScannedCode(_ code: String) async {
        await MainActor.run { partViewModel.isLoading = true }

        // 문자열 → Int 변환 (QR 코드가 숫자 아닐 경우 예외 처리)
        guard let partId = Int(code) else {
            await MainActor.run {
                partViewModel.isLoading = false
                alertMessage = "잘못된 QR 코드입니다. (숫자형 ID가 아닙니다)"
                showAlert = true
            }
            return
        }

        // ✅ 부품 상세 조회 API 호출
        await partViewModel.fetchPartDetail(partIds: partId)

        // ✅ 결과 출력
        await MainActor.run {
            partViewModel.isLoading = false

            guard let response = partViewModel.partDetails.first else {
               alertMessage = "부품 정보를 불러오지 못했습니다."
               showAlert = true
               return
           }
            
            // ✅ 응답을 PartDetail로 변환 후 저장
            let newPart = PartDetail(
                id: response.id,
                price: response.price,
                image: response.image,
                trim: response.trim,
                model: response.model,
                korName: response.korName,
                categoryName: response.categoryName,
                quantity: 1
            )
            
            partStore.addPart(newPart)
            
            // ✅ 자동으로 바텀시트 열기
           showBottomSheet = true

           // ✅ 스캔 상태 초기화 (다시 스캔 가능하도록)
           resetScanState()
            
            print("✅ \(newPart.korName) 부품이 전역 Store에 추가됨")
        }
    }
    
    // ✅ 상태 초기화 (QR 다시 활성화)
    private func resetScanState() {
        scannedCode = nil
        scannerRestartTrigger.toggle()
    }
}
