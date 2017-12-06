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
    var draggingEnabled: Bool { didSet { panGesture.isEnabled = draggingEnabled } }
    
    private let stars: [UIImageView]
    private let panGesture = UIPanGestureRecognizer()
    private let starContainer = UIView()
    
    var rating: StarRating? {
        didSet {
            let ceilRating = Int(ceil(rating?.rawValue ?? 0))
            
            guard let rating = rating, ceilRating != 0 else {
                stars.forEach() { $0.image = R.image.emptyStar() }
                return
            }
            
            for i in 0...ceilRating - 1 {
                let star = stars[i]
                if i == ceilRating - 1 && rating.rawValue < Double(ceilRating) {
                    star.image = R.image.halfStarLeft()
                } else {
                    star.image = R.image.fullStar()
                }
            }
            
            for i in ceilRating..<5 { stars[i].image = R.image.emptyStar() }
        }
    }
    
    init(draggingEnabled: Bool = false) {
        self.draggingEnabled = draggingEnabled
        stars = (0..<5).map() { _ in UIImageView() }
        
        super.init(frame: .zero)
        
        addSubview(starContainer)
        starContainer <- [
            CenterX(),
            CenterY(),
            Leading(>=0),
            Leading().with(.low),
            Top(>=0),
            Top().with(.low)
        ]
        
        for i in 0..<stars.count {
            let star = stars[i]
            starContainer.addSubview(star)
            
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
        
        panGesture.isEnabled = draggingEnabled
        _ = panGesture.rx.event.asObservable().takeUntil(rx.deallocated).subscribe(onNext: { pan in
            guard let view = pan.view else { return }
            self.updateWithTouch(location: pan.location(in: view))
        })
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        updateWithTouch(location: touch.location(in: self))
    }
    
    private func updateWithTouch(location: CGPoint) {
        let starWidth = self.starContainer.frame.width
        let location = location.x - self.starContainer.frame.origin.x
        self.rating = {
            var rating = Double(location / starWidth) * StarRating.five.rawValue
            let denominator: Double = 2
            rating = (rating * denominator).rounded(.toNearestOrAwayFromZero) / denominator
            return StarRating(rawValue: rating)
        }()
    }
}
