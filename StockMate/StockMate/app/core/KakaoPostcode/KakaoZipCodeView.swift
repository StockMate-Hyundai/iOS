//
//  KakaoZipCodeView.swift
//  StockMate
//
//  Created by Admin on 11/5/25.
//


import SwiftUI
import WebKit

struct KakaoZipCodeView: UIViewControllerRepresentable {
    @Binding var address: String

    func makeUIViewController(context: Context) -> KakaoZipCodeVC {
        let vc = KakaoZipCodeVC()
        vc.onAddressSelected = { selectedAddress in
            address = selectedAddress
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: KakaoZipCodeVC, context: Context) {}
}
