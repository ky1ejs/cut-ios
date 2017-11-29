//
//  WatchActionView.swift
//  Cut
//
//  Created by Kyle McAlpine on 18/06/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy
import RxSwift


// States

// * film rated - show stars
// * film on watch list - show rate and remove watch buttons
// * neither of the above - show rate and watch buttons

class WatchActionView: UIView {
    let film                    : Film
    let ratingView              : StarRatingView
    let rateButton              = UIButton()
    let addWatchListButton      = UIButton()
    let removeWatchListButton   = UIButton()
    
    init(film: Film) {
        self.film = film
        ratingView = StarRatingView()
        
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
        
        _ = film.status.asObservable().takeUntil(rx.deallocated).bind(to: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WatchActionView: ObserverType {
    typealias E = FilmStatus?
    
    func on(_ event: Event<FilmStatus?>) {
        guard case .next(let status) = event else { return }
        
        switch status {
        case .rated(let rating)?:
            rateButton.alpha = 0
            addWatchListButton.alpha = 0
            removeWatchListButton.alpha = 0
            ratingView.alpha = 1
            ratingView.rating = rating
        case .wantToWatch?:
            rateButton.alpha = 1
            addWatchListButton.alpha = 0
            removeWatchListButton.alpha = 1
            ratingView.alpha = 0
        default:
            rateButton.alpha = 1
            addWatchListButton.alpha = 1
            removeWatchListButton.alpha = 0
            ratingView.alpha = 0
        }
    }
}
