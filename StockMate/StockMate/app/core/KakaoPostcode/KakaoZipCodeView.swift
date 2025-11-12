//
//  KakaoZipCodeView.swift
//  StockMate
//
//  Created by Admin on 11/5/25.
//


import SwiftUI
import WebKit

// SwiftUI에서 UIKit 기반의 Kakao 우편번호 검색 화면을 사용하기 위한 래퍼 뷰
// UIViewControllerRepresentable을 통해 KakaoZipCodeVC를 SwiftUI에 통합
struct KakaoZipCodeView: UIViewControllerRepresentable {
    // 선택된 주소 값을 SwiftUI와 바인딩
    @Binding var address: String

    // KakaoZipCodeVC 생성 및 초기 설정
    func makeUIViewController(context: Context) -> KakaoZipCodeVC {
        let vc = KakaoZipCodeVC()
        
        // 주소가 선택되었을 때 SwiftUI 바인딩 변수로 전달
        vc.onAddressSelected = { selectedAddress in
            address = selectedAddress
        }
        return vc
    }
    
    // UIViewController 상태 갱신 (현재는 별도 갱신 로직 없음)
    func updateUIViewController(_ uiViewController: KakaoZipCodeVC, context: Context) {}
}
