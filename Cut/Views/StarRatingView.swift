//
//  StarRatingView.swift
//  Cut
//
//  Created by Kyle McAlpine on 15/05/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

class StarRatingView: UIView {
    private let stars: [UIImageView]
    
    var rating: StarRating? {
        didSet {
            guard let rating = rating else {
                stars.forEach() { $0.image = nil }
                return
            }
            
            let ceilRating = Int(ceil(rating.rawValue))
            
            guard ceilRating != 0 else {
                stars.forEach() { $0.image = R.image.emptyStar() }
                return
            }
            
            guard ceilRating != 5 else {
                stars.forEach() { $0.image = R.image.fullStar() }
                return
            }
            
            for i in 0...ceilRating {
                let star = stars[i]
                if i == ceilRating && rating.rawValue > Double(ceilRating) - 1 {
                    star.image = R.image.halfStarLeft()
                } else {
                    star.image = R.image.fullStar()
                }
            }
            
            for i in (ceilRating + 1)..<5 { stars[i].image = R.image.emptyStar() }
        }
    }
    
    init() {
        stars = (0..<5).map() { _ in UIImageView() }
        
        super.init(frame: .zero)
        
        let container = UIView()
        addSubview(container)
        container <- [
            CenterX(),
            CenterY(),
            Leading(>=0),
            Leading().with(.low),
            Top(>=0),
            Top().with(.low)
        ]
        
        for i in 0..<stars.count {
            let star = stars[i]
            container.addSubview(star)
            
            if i > 0 {
                star <- Leading(10).to(stars[i - 1])
            } else {
                star <- Leading()
            }
            
            star <- [
                Top(),
                Size(20),
                Bottom()
            ]
            
            if i == stars.count - 1 { star <- Trailing() }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
