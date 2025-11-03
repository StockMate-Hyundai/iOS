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
    
    // 사용 처리 임시
    @EnvironmentObject var partStore: PartStore
    @State private var showBottomSheet = false
    
    @State private var scannerRestartTrigger = false

//    @State private var isPresentingBottomSheet = false
    @State private var partDetail: PartDetail? = nil
    
    @StateObject private var partViewModel = PartViewModel() // ✅ ViewModel 추가

    var body: some View {
        ZStack {
            // ✅ 카메라 미리보기 (QR 스캐너)
            QRScannerView(scannedCode: $scannedCode)
                .id(scannerRestartTrigger) // 👈 다시 렌더링되어 카메라 리셋됨
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
                  ProgressView("부품 조회 중...")
                      .padding()
                      .background(.ultraThinMaterial)
                      .cornerRadius(10)
              }
//            if partViewModel.isLoading {
//                Color.black.opacity(0.3).ignoresSafeArea()
//                ProgressView("부품 사용 처리 중...")
//                    .padding()
//                    .background(.ultraThinMaterial)
//                    .cornerRadius(10)
//            }
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
               if let part = partDetail {
                   PartBottomSheetView(
                       part: part,
                       onAddPart: {
                           // ✅ 부품 추가 버튼 액션
                           partStore.addPart(part)

                           // ✅ 상태 초기화 (QR 다시 가능하도록)
                           resetScanState()
                       },
                       onUseParts: {
                           // ✅ 사용 처리 버튼 액션 (예: 서버 전송)
                           let payload = partStore.makeRequestPayload()
                           print("🚀 사용 처리 API 호출 payload:", payload)
                       }
                   )
                   .environmentObject(partStore)
               }
           }
           .navigationTitle("부품 사용 처리")
           .navigationBarTitleDisplayMode(.inline)
//           .sheet(isPresented: $showBottomSheet) {
//               PartBottomSheetView()
//                   .environmentObject(partStore)
//           }
//           .navigationTitle("부품 사용 처리")
//           .navigationBarTitleDisplayMode(.inline)
        
        //-----//
//        // ✅ 알림창
//        .alert("부품 사용 결과", isPresented: $showAlert) {
//            Button("확인") {
//                dismiss()
//            }
//        } message: {
//            Text(alertMessage)
//        }
//        // ✅ QR 스캔 이벤트 발생 시
//        .onChange(of: scannedCode) { newValue in
//            guard let code = newValue, !code.isEmpty else { return }
//            Task {
//                await handleScannedCode(code)
//            }
//        }
//        .navigationTitle("부품 사용 처리")
//        .navigationBarTitleDisplayMode(.inline)
    }
    
    // ✅ 스캔된 코드로 부품 상세 조회만 수행 (출고 X)
    private func handleScannedCode(_ code: String) async {
        await MainActor.run {
            partViewModel.isLoading = true
        }

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
        await partViewModel.fetchPartDetail(partId: partId)

        // ✅ 결과 출력
        await MainActor.run {
            partViewModel.isLoading = false

            guard let response = partViewModel.partDetails.first else {
               alertMessage = "부품 정보를 불러오지 못했습니다."
               showAlert = true
               return
           }

            partDetail = PartDetail(
                  id: response.id,
                  price: response.price,
                  image: response.image,
                  trim: response.trim,
                  model: response.model,
                  korName: response.korName,
                  categoryName: response.categoryName,
                  quantity: 1
              )
//            // ✅ API 응답을 PartDetail로 변환
//              let newPart = PartDetail(
//                  id: response.id,
//                  price: response.price,
//                  image: response.image,
//                  trim: response.trim,
//                  model: response.model,
//                  korName: response.korName,
//                  categoryName: response.categoryName,
//                  quantity: 1
//              )
//            
//              // ✅ 리스트에 추가
//              partStore.addPart(newPart)

              // ✅ 바텀 시트 띄우기
              showBottomSheet = true
            
            //-----///
            
//            if let part = partViewModel.partDetails.first {
//                print("✅ 부품 상세 조회 성공")
//                print("ID:", part.id)
//                print("이름:", part.name)
//                print("가격:", part.price)
//                print("모델:", part.model)
//                print("트림:", part.trim)
//                print("코드:", part.code)
//                alertMessage = "부품 조회 성공: \(part.name)"
//            } else {
//                print("⚠️ 부품 정보를 불러오지 못함")
//                alertMessage = "부품 정보를 불러오지 못했습니다."
//            }
//
//            showAlert = true
        }
    }

//    // ✅ 스캔된 코드로 출고 API 호출
//    private func handleScannedCode(_ code: String) async {
//        await MainActor.run {
//            partViewModel.isLoading = true
//        }
//
//        // ✅ 문자열 → Int 변환 (QR 코드가 숫자 아닐 경우 예외 처리)
//        guard let partId = Int(code) else {
//            await MainActor.run {
//                partViewModel.isLoading = false
//                alertMessage = "잘못된 QR 코드입니다. (숫자형 ID가 아닙니다)"
//                showAlert = true
//            }
//            return
//        }
//
//        // ✅ 요청 생성 및 API 호출
//        let request = [ReleaseItemRequest(partId: partId, quantity: 1)] // 기본 1개 사용
//        let result = await partViewModel.releaseParts(items: request)
//
//        await MainActor.run {
//            partViewModel.isLoading = false
//            switch result {
//            case .success(let message):
//                alertMessage = message
//            case .failure(let error):
//                alertMessage = error.message
//            }
//            showAlert = true
//        }
//    }
    
    // ✅ 상태 초기화 (QR 다시 활성화)
    private func resetScanState() {
        scannedCode = nil
        partDetail = nil
        showBottomSheet = false
        partViewModel.partDetails.removeAll()
        
        // ✅ 카메라 세션 재시작
        scannerRestartTrigger.toggle()
    }

}

//#Preview {
//    NavigationStack {
//        OutgoingScanView()
//    }
//}
