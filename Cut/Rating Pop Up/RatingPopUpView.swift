//
//  RatingPopUpView.swift
//  Cut
//
//  Created by Kyle McAlpine on 29/11/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

class RatingPopUpView: UIView {
    let ratingView = StarRatingView(draggingEnabled: true)
    let rateButton = UIButton()
    let cancelButton = UIButton()
    
    init(rating: StarRating?) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        ratingView.rating = rating
        
        rateButton.setTitle("Rate", for: .normal)
        rateButton.setTitleColor(.red, for: .normal)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        
        let starRatingContainer = UIView()
        starRatingContainer.addSubview(ratingView)
        addSubview(starRatingContainer)
        addSubview(rateButton)
        addSubview(cancelButton)
        
        ratingView.easy.layout([
            Width(180),
            Height(90),
            Edges(10)
        ])
        starRatingContainer.easy.layout([CenterX(), CenterY()])
        cancelButton.easy.layout([
            Leading(),
            Bottom(),
            Height(50)
        ])
        rateButton.easy.layout([
            Leading().to(cancelButton),
            Trailing(),
            Bottom(),
            Height().like(cancelButton),
            Width().like(cancelButton)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
