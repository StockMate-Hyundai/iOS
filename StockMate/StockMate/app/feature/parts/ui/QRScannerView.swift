//
//  QRScannerView.swift
//  StockMate
//
//  Created by Admin on 10/31/25.
//

import SwiftUI

struct QRScannerView: UIViewControllerRepresentable {
    @Binding var scannedCode: String?

    func makeUIViewController(context: Context) -> QRScannerViewController {
        let controller = QRScannerViewController()
        controller.delegate = context.coordinator
        return controller
    }

//    func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {}
    func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {
        // ✅ scannedCode가 nil이면 다시 스캔 시작
        if scannedCode == nil {
            uiViewController.startScanning()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, QRScannerDelegate {
        let parent: QRScannerView

        init(_ parent: QRScannerView) {
            self.parent = parent
        }

        func didScanQRCode(_ code: String) {
            parent.scannedCode = code
        }
    }
}
