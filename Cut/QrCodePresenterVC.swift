//
//  QrCodePresenterVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 19/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import UIKit
import Kingfisher

class QrCodePresenterVC: UIViewController {
    override func loadView() {
        let qrView = QrCodePresenterView()
        qrView.imageView.kf.indicatorType = .activity
        let modifier = KingfisherOptionsInfoItem.requestModifier(CutQrCodeImageDownloadRequestModifier())
        qrView.imageView.kf.setImage(with: CutEndpoints.qrCode, placeholder: nil, options: [modifier])
        qrView.doneButton.rx.tap.asObservable().subscribe(onNext: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        view = qrView
    }
}
