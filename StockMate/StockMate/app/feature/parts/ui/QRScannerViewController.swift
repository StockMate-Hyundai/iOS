//
//  QRScannerViewController.swift
//  StockMate
//
//  Created by Admin on 10/31/25.
//

import UIKit
import AVFoundation

protocol QRScannerDelegate: AnyObject {
    func didScanQRCode(_ code: String)
}

final class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    weak var delegate: QRScannerDelegate?

    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession.canAddInput(videoInput)
        else {
            print("카메라 입력 불가")
            return
        }

        captureSession.addInput(videoInput)

        let metadataOutput = AVCaptureMetadataOutput()
        guard captureSession.canAddOutput(metadataOutput) else {
            print("출력 연결 불가")
            return
        }

        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        
        startScanning()
        // ⚠️ 백그라운드에서 실행
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.captureSession.startRunning()
//        }
    }
    
    // ✅ 스캔 재시작/중단 함수 추가
    func startScanning() {
        guard captureSession != nil else { return }
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }

    func stopScanning() {
        guard captureSession != nil else { return }
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func startSession() {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }

    func stopSession() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    
    // ✅ QR 감지 시 호출
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            captureSession.stopRunning()
            delegate?.didScanQRCode(stringValue)
        }
    }
}

