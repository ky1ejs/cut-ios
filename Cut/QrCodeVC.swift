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
        
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        let captureSession = AVCaptureSession()
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.qr]
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        qrView.scannerContainer.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = qrView.scannerContainer.bounds
    }
    
    func follow(user: String) {
        qrView.mode = .loading
        _ = FollowUnfollowUser(username: user, follow: true).call().observeOn(MainScheduler.instance).subscribe { event in
            switch event {
            case .completed, .next(_):
                self.qrView.mode = .scan
            case .error:
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
        follow(user: username)
    }
}
