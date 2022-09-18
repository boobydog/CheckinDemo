//
//  CameraPreview.swift
//  CheckinApp
//
//  Created by j-sys on 2022/06/16.
//カメラの映像を表示するためのUIViewです。
//これはUIKitのビューで、最終的にはSwiftUIのレイアウトでUIViewRepresentableを使って表示されます。

import UIKit
import AVFoundation

class CameraPreview: UIView {

    private var label:UILabel?

    var previewLayer: AVCaptureVideoPreviewLayer?
    var session = AVCaptureSession()
    weak var delegate: QrCodeCameraDelegate?

    init(session: AVCaptureSession) {
        super.init(frame: .zero)
        self.session = session
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onClick(){
        delegate?.onSimulateScanning()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = self.bounds
    }
}
