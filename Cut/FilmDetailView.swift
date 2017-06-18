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
import AVKit

class FilmDetailView: UIView {
    let trailerView         = UIImageView()
    let posterImageView     = UIImageView()
    let watchView           : WatchView
    let titleLabel          = UILabel()
    let releaseDateLabel    = UILabel()
    let runningTimeLabel    = UILabel()
    let synopsisLabel       = UILabel()

    let film: Film
    
    init(film: Film) {
        self.film = film
        watchView = WatchView(film: film)
        
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        posterImageView.kf.setImage(with: film.profileImageURL)
        synopsisLabel.text = film.synopsis
        
        titleLabel.text = film.title
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        
        releaseDateLabel.font = UIFont.systemFont(ofSize: 17)
        releaseDateLabel.textColor = .lightGray
        
        runningTimeLabel.font = UIFont.systemFont(ofSize: 17)
        runningTimeLabel.textColor = .lightGray
        
        if let releaseDate = film.theaterReleaseDate {
            let df = DateFormatter()
            df.dateFormat = "d MMM, yy"
            releaseDateLabel.text = df.string(from: releaseDate)
        }
        
        if let runningTime = film.runningTime {
            let hoursFloat = Float(runningTime) / 60
            let hours = Int(floor(hoursFloat))
            let minutes = runningTime % 60
            
            var runningTimeString = ""
            if hours > 0 {
                runningTimeString = "\(hours) hr\(hours > 1 ? "s" : "")"
            }
            if minutes > 0 {
                runningTimeString = "\(runningTimeString.count > 0 ? runningTimeString + " " : "")\(minutes) min\(minutes > 1 ? "s" : "")"
            }
            runningTimeLabel.text = runningTimeString
        }
        
        trailerView.backgroundColor = .black
        posterImageView.backgroundColor = .gray
        
        titleLabel.numberOfLines = 2
        synopsisLabel.numberOfLines = 0
        
        addSubview(trailerView)
        addSubview(posterImageView)
        addSubview(watchView)
        addSubview(titleLabel)
        addSubview(releaseDateLabel)
        addSubview(runningTimeLabel)
        addSubview(synopsisLabel)
        
        let ratings = film.ratings.filter {
            r -> Bool in return r.source == .flixsterUsers ||
                r.source == .cutUsers ||
                r.source == .rottenTomatoes
        }
        let ratingViews = ratings.map(CircularRatingView.init)
        var lastRatingView: CircularRatingView?
        for v in ratingViews {
            addSubview(v)
            if let lastRatingView = lastRatingView {
                v <- Leading(40).to(lastRatingView)
            } else {
                v <- Leading(40)
            }
            
            v <- Top(30).to(synopsisLabel)
            
            lastRatingView = v
        }
        
        trailerView <- [
            Top(),
            Leading(),
            Width().like(self),
            Height(*0.5625).like(trailerView, .width)
        ]
        
        posterImageView <- [
            Leading(40),
            CenterY(-20).to(trailerView, .bottom),
            Width(100),
            Height(*CGFloat.posterWidthToHeightRation).like(posterImageView, .width)
        ]
        
        watchView <- [
            Leading(20).to(posterImageView),
            Bottom().to(posterImageView, .bottom),
            Trailing(40)
        ]
        
        titleLabel <- [
            Top(15).to(posterImageView),
            Leading().to(posterImageView, .leading),
            CenterX()
        ]
        
        releaseDateLabel <- [
            Top(5).to(titleLabel),
            Leading().to(titleLabel, .leading)
        ]
        
        runningTimeLabel <- [
            Bottom().to(releaseDateLabel, .bottom),
            Leading(15).to(releaseDateLabel)
        ]
        
        synopsisLabel <- [
            Top(20).to(releaseDateLabel),
            Leading().to(releaseDateLabel, .leading),
            CenterX()
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
