//
//  WatchView.swift
//  Cut
//
//  Created by Kyle McAlpine on 18/06/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

class WatchView: UIView {
    let film                : Film
    let ratingView          : UserRatingView
    let rateButton          = UIButton()
    let addWatchListButton  = UIButton()
    
    init(film: Film) {
        self.film = film
        ratingView = UserRatingView()
        
        super.init(frame: .zero)
        
        ratingView.rating = film.status.value?.ratingScore
        
        rateButton.setImage(R.image.fullStar(), for: .normal)
        rateButton.imageView?.contentMode = .scaleAspectFit
        rateButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        rateButton.backgroundColor = .red
        
        addWatchListButton.setTitle("+", for: .normal)
        addWatchListButton.backgroundColor = .red
        
        addSubview(ratingView)
        addSubview(rateButton)
        addSubview(addWatchListButton)
        
        self <- Height(35)
        
        ratingView <- [
            Leading(),
            Top(),
            Bottom(),
            Trailing()
        ]
        
        rateButton <- [
            Leading(),
            Top(),
            Bottom()
        ]
        
        addWatchListButton <- [
            Leading(20).to(rateButton),
            Top(),
            Bottom(),
            Trailing(),
            Width().like(rateButton)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
