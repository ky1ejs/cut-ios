//
//  Star.swift
//  Cut
//
//  Created by Kyle McAlpine on 16/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

enum StarSize {
    case empty
    case half
    case full
    
    var image: UIImage? {
        switch self {
        case .empty: return nil
        case .half: return R.image.halfStar()
        case .full: return R.image.fullStar()
        }
    }
}

class Star: UIView {
    var size: StarSize {
        didSet {
            imageView.image = size.image
        }
    }
    private let imageView = UIImageView()
    
    init(size: StarSize) {
        self.size = size
        
        super.init(frame: .zero)
        
        imageView.image = size.image
        addSubview(imageView)
        
        imageView <- [
            CenterX(),
            CenterY(),
            Top().with(.low),
            Leading().with(.low),
            Leading(>=0),
            Top(>=0),
            Width(1.051467785).like(imageView, .height)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
