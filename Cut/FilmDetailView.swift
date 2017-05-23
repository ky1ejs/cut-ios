//
//  FilmDetailView.swift
//  Cut
//
//  Created by Kyle McAlpine on 15/05/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy
import Kingfisher

class FilmDetailView: UIView {
    let posterImageView     = UIImageView()
    let titleLabel          = UILabel()
    let synopsisLabel       = UILabel()
    let runningTimeLabel    = UILabel()
    let userRatingView      = UserRatingView()

    let film: Film
    
    init(film: Film) {
        self.film = film
        
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        posterImageView.kf.setImage(with: film.profileImageURL)
        titleLabel.text         = film.title
        synopsisLabel.text      = film.synopsis
        runningTimeLabel.text   = String(describing: film.runningTime)
        userRatingView.rating   = film.status.value?.ratingScore
        
        titleLabel.numberOfLines = 0
        synopsisLabel.numberOfLines = 0
        
        addSubview(posterImageView)
        addSubview(titleLabel)
        addSubview(synopsisLabel)
        addSubview(runningTimeLabel)
        addSubview(userRatingView)
        
        posterImageView <- [
            Leading(20),
            Top(50),
            Width(100),
            Height(*CGFloat.posterWidthToHeightRation).like(posterImageView, .width)
        ]
        
        titleLabel <- [
            Top().to(posterImageView, .top),
            Leading(30).to(posterImageView),
            Trailing(20)
        ]
        
        runningTimeLabel <- [
            Top(10).to(titleLabel),
            Leading().to(titleLabel, .leading)
        ]
        
        synopsisLabel <- [
            Top(20).to(posterImageView),
            Leading(20),
            CenterX()
        ]
        
        userRatingView <- [
            Leading().to(runningTimeLabel, .leading),
            Top(10).to(runningTimeLabel)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
