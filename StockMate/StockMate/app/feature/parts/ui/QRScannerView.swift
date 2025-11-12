//
//  QRScannerView.swift
//  StockMate
//
//  Created by Admin on 10/31/25.
//

import SwiftUI

struct QRScannerView: UIViewControllerRepresentable {
    @Binding var scannedCode: String?
    var isActive: Bool = true

    func makeUIViewController(context: Context) -> QRScannerViewController {
        let controller = QRScannerViewController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {
            if isActive {
                uiViewController.startSession()   // 바텀시트 닫혔을 때 다시 스캔 시작
            } else {
                uiViewController.stopSession()    // 바텀시트 열렸을 때 스캔 일시정지
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
