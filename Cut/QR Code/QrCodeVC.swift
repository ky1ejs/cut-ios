//
//  QrCodeVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 19/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import RxSwift

class QrCodeVC: UIViewController {
    let qrView = QrCodeView()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func loadView() {
        view = qrView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrView.imageView.kf.indicatorType = .activity
        let modifier = KingfisherOptionsInfoItem.requestModifier(CutQrCodeImageDownloadRequestModifier())
        qrView.imageView.kf.setImage(with: CutEndpoints.qrCode, placeholder: nil, options: [modifier])
        _ = qrView.doneButton.rx.tap.asObservable().subscribe(onNext: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: .back)
        
        let captureSession = AVCaptureSession()
        do {
            guard let captureDevice = deviceDiscoverySession.devices.first else {
                print("Failed to get the camera device")
                return
            }
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch let error {
            print(error)
            return
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [.qr]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        qrView.scannerContainer.layer.addSublayer(videoPreviewLayer!)
        
        captureSession.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = qrView.scannerContainer.bounds
    }
    
    func presentUserWith(username: String) {
        qrView.mode = .loading
        _ = GetUser(username: username).call().observeOn(MainScheduler.instance).subscribe { event in
            switch event {
            case .next(let user):
                let vc = UINavigationController(rootViewController: UserVC(user: user))
                self.present(vc, animated: true, completion: {
                    self.qrView.mode = .scan
                })
            default:
                self.qrView.mode = .scan
            }
        }
    }
}

extension QrCodeVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard qrView.mode == .scan else { return }
        guard let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
        guard metadataObj.type == .qr else { return }
        guard let username = metadataObj.stringValue else { return }
        presentUserWith(username: username)
    }
}
