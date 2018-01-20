//
//  QrCodePresenterView.swift
//  Cut
//
//  Created by Kyle McAlpine on 19/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

class QrCodePresenterView: UIView {
    let imageView = UIImageView()
    let doneButton = UIButton(type: .custom)
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.blue, for: .normal)
        
        addSubview(imageView)
        addSubview(doneButton)
        
        imageView <- [
            CenterX(),
            CenterY(),
            Leading(30),
            Height().like(imageView, .width)
        ]
        
        doneButton <- [
            Top(20).to(safeAreaLayoutGuide, .top),
            Trailing(20)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
