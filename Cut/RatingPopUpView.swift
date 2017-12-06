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
    
    init(rating: StarRating?) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        ratingView.rating = rating
        
        let starRatingContainer = UIView()
        starRatingContainer.addSubview(ratingView)
        addSubview(starRatingContainer)
        
        ratingView <- [
            Width(180),
            Height(90),
            Edges(10)
        ]
        starRatingContainer <- [CenterX(), CenterY()]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
