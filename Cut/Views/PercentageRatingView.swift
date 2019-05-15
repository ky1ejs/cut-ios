//
//  PercentageRatingView.swift
//  Cut
//
//  Created by Kyle McAlpine on 09/05/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

class PercentageRatingView: UIView {
    private let label = UILabel()
    let icon = UIImageView()
    
    var rating: PercentageRating? {
        didSet {
            guard let rating = rating else {
                label.text = nil
                icon.image = nil
                return
            }
            
            label.text = "%\(Int(rating.score * 100))"
            icon.image = rating.icon
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        label.font = .systemFont(ofSize: 9)
        
        addSubview(label)
        addSubview(icon)
        
        icon.easy.layout([
            Leading(),
            Top(),
            CenterY(),
            Size(20)
        ])
        
        label.easy.layout([
            Leading(3).to(icon),
            Top(),
            CenterY(),
            Trailing(),
            Size(CGSize(width: 30, height: 20))
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
