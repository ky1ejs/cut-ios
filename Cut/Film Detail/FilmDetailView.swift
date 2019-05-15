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
    let scrollView          = UIScrollView()
    let trailerButton       = UIButton()
    let posterImageView     = UIImageView()
    let watchView           : WatchActionView
    let titleLabel          = UILabel()
    let releaseDateLabel    = UILabel()
    let runningTimeLabel    = UILabel()
    let synopsisLabel       = UILabel()

    let film: Film
    
    init(film: Film) {
        self.film = film
        watchView = WatchActionView(film: film)
        
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
        
        trailerButton.backgroundColor = .black
        posterImageView.backgroundColor = .gray
        
        titleLabel.numberOfLines = 2
        synopsisLabel.numberOfLines = 0
        
        trailerButton.kf.setBackgroundImage(with: film.trailers?.first?.previewImageURL, for: .normal)
        
        addSubview(scrollView)
        scrollView.addSubview(trailerButton)
        scrollView.addSubview(posterImageView)
        scrollView.addSubview(watchView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(releaseDateLabel)
        scrollView.addSubview(runningTimeLabel)
        scrollView.addSubview(synopsisLabel)
        
        let ratingViews: [RatingSource : CircularRatingView] = [
            .cutUsers       : CircularRatingView(),
            .rottenTomatoes : CircularRatingView(),
            .flixsterUsers  : CircularRatingView()
        ]
        let orderedKeys: [RatingSource] = [.cutUsers, .rottenTomatoes, .flixsterUsers]
        var ratingsBySource = [RatingSource : PercentageRating]()
        film.ratings.forEach() { ratingsBySource[$0.source] = $0 }
        ratingViews.forEach { $0.value.rating = ratingsBySource[$0.key] }
        
        let ratingsContainer = UIView()
        
        ratingsContainer.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        var spacers = [UIView]()
        for i in 0..<orderedKeys.count {
            guard let v = ratingViews[orderedKeys[i]] else { continue }
            
            let spacer = UIView()
            spacers.append(spacer)
            ratingsContainer.addSubview(spacer)
            if i > 0 {
                spacer.easy.layout(Leading().to(ratingViews[orderedKeys[i - 1]]!))
            } else {
                spacer.easy.layout(Leading())
            }
            spacer.easy.layout([Top(), Bottom()])
            
            ratingsContainer.addSubview(v)
            v.easy.layout([Leading().to(spacer), Top(), Bottom()])
            
            if i == orderedKeys.count - 1 {
                let trailingSpacer = UIView()
                spacers.append(trailingSpacer)
                ratingsContainer.addSubview(trailingSpacer)
                trailingSpacer.easy.layout([Leading().to(v), Top(), Bottom(), Trailing()])
            }
        }
        
        var previousSpacer: UIView?
        for s in spacers {
            guard let prev = previousSpacer else {
                previousSpacer = s
                continue
            }
            s.easy.layout(Width().like(prev))
            previousSpacer = s
        }
        scrollView.addSubview(ratingsContainer)
        
        
        // Layout
        scrollView.easy.layout([
            Top().to(safeAreaLayoutGuide, .top),
            Leading(),
            CenterX(),
            Bottom()
        ])
        
        trailerButton.easy.layout([
            Top(10),
            Leading(),
            Trailing(),
            Width().like(self),
            Height(*0.5625).like(trailerButton, .width)
        ])
        
        posterImageView.easy.layout([
            Leading(40),
            CenterY(-20).to(trailerButton, .bottom),
            Width(100),
            Height(*CGFloat.posterWidthToHeightRation).like(posterImageView, .width)
        ])
        
        watchView.easy.layout([
            Leading(20).to(posterImageView),
            Bottom().to(posterImageView, .bottom),
            Trailing(40).to(trailerButton, .trailing)
        ])
        
        titleLabel.easy.layout([
            Top(15).to(posterImageView),
            Leading().to(posterImageView, .leading),
            CenterX()
        ])
        
        releaseDateLabel.easy.layout([
            Top(5).to(titleLabel),
            Leading().to(titleLabel, .leading)
        ])
        
        runningTimeLabel.easy.layout([
            Bottom().to(releaseDateLabel, .bottom),
            Leading(15).to(releaseDateLabel)
        ])
        
        synopsisLabel.easy.layout([
            Top(20).to(releaseDateLabel),
            Leading().to(releaseDateLabel, .leading),
            CenterX()
        ])
        
        ratingsContainer.easy.layout([
            Leading().to(synopsisLabel, .leading),
            Trailing().to(synopsisLabel, .trailing),
            Top(15).to(synopsisLabel),
            Bottom(30)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
