//
//  QrCodeCameraDelegate.swift
//  CheckinApp
//
//  Created by j-sys on 2022/06/16.
//QRコードが見つかったかどうかをチェックして、そのQRコードの値を親Viewに通知するデリゲート

import AVFoundation

class QrCodeCameraDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {

    var scanInterval: Double = 1.0
    var lastTime = Date(timeIntervalSince1970: 0)

    var onResult: (String) -> Void = { _  in }
    var mockData: String?

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            foundBarcode(stringValue)
        }
    }

    @objc func onSimulateScanning(){
        foundBarcode(mockData ?? "Simulated QR-code result.")
    }

    func foundBarcode(_ stringValue: String) {
        let now = Date()
        if now.timeIntervalSince(lastTime) >= scanInterval {
            lastTime = now
            self.onResult(stringValue)
        }
    }
}
