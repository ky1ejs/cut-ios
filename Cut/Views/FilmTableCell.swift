//
//  FilmTableCell.swift
//  Cut
//
//  Created by Kyle McAlpine on 24/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import Kingfisher
import EasyPeasy

class FilmTableCell: UITableViewCell {
    fileprivate var _textLabel: UILabel
    override var textLabel: UILabel {
        get { return _textLabel }
        set { _textLabel = newValue }
    }
    let releaseDateLabel = UILabel()
    var posterImageView: UIImageView
    
    let ratingViews: [RatingSource : PercentageRatingView] = [
        .cutUsers : PercentageRatingView(),
        .rottenTomatoes : PercentageRatingView(),
        .flixsterUsers : PercentageRatingView(),
        .imdbUsers :PercentageRatingView()
    ]
    
    let panGesture = UIPanGestureRecognizer()
    var originalCenter = CGPoint.zero
    
    let stars: [Star] = {
        return (0..<5).map() { _ in Star(size: .full) }
    }()
    var ratingActionView: UIView?
    
    let glasses: UIView = {
        let glasses = UIView()
        glasses.backgroundColor = .blue
        return glasses
    }()
    var watchActionView: UIView?
    
    var film: Film? {
        didSet {
            var ratingsBySource = [RatingSource : PercentageRating]()
            film?.ratings.forEach() { ratingsBySource[$0.source] = $0 }
            ratingViews.forEach { $0.value.rating = ratingsBySource[$0.key] }
            
            guard let film = film else {
                textLabel.text = nil
                posterImageView.image = nil
                releaseDateLabel.text = nil
                return
            }
            
            textLabel.text = film.title
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: film.profileImageURL, placeholder: nil, options: [.transition(.fade(0.3))])
            backgroundColor = film.status.value == .wantToWatch ? .red : .white
            releaseDateLabel.text = film.relativeTheaterReleaseDate
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        _textLabel = UILabel()
        posterImageView = UIImageView()
        
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        releaseDateLabel.textColor = .gray
        releaseDateLabel.font = .systemFont(ofSize: 10)
        
        contentView.addSubview(textLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(posterImageView)
        
        let orderedRatingViewSources: [RatingSource] = [.cutUsers, .rottenTomatoes, .flixsterUsers, .imdbUsers]
        
        var previousRatingView: PercentageRatingView?
        for key in orderedRatingViewSources {
            guard let view = ratingViews[key] else { continue }
                
            contentView.addSubview(view)
            
            view.easy.layout(Bottom().to(posterImageView, .bottom))
            
            if let previousRatingView = previousRatingView {
                view.easy.layout(Leading(15).to(previousRatingView))
            } else {
                view.easy.layout(Leading(60).to(posterImageView))
            }
            
            previousRatingView = view
        }
        
        textLabel.easy.layout([
            Bottom(2).to(self, .centerY),
            Leading(30).to(posterImageView),
            Trailing(5)
        ])
        
        releaseDateLabel.easy.layout([
            Top(2).to(self, .centerY),
            Leading().to(textLabel, .leading)
        ])
        
        posterImageView.easy.layout([
            Top(5),
            CenterY(),
            Leading(5),
            Size(CGSize(width: 61, height: 91))
        ])
        
        panGesture.addTarget(self, action: #selector(pan(gesture:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pan(gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: view).x
        
        switch gesture.state {
        case .began:
            addRatingActionView()
            addWatchActionView()
            originalCenter = center
        case .changed:
            guard let ratingActionView = ratingActionView else { return }
            guard let watchActionView = watchActionView else { return }
            
            let starPadding: CGFloat = 10
            for star in stars {
                let starEndX = star.frame.origin.x + star.frame.width
                let halfThreshold = starEndX - (star.frame.width / 2) + starPadding
                let fullThreshold = starEndX + starPadding
                
                star.size = {
                    switch translation {
                    case halfThreshold..<fullThreshold:
                        return .half
                    case fullThreshold...CGFloat.greatestFiniteMagnitude:
                        return .full
                    default:
                        return .empty
                    }
                }()
            }
            
            center = CGPoint(x: originalCenter.x + translation, y: originalCenter.y)
            
            ratingActionView.easy.layout(Width(translation))
            watchActionView.easy.layout(Width(-translation))
            
            let fullColorThreshold          = glasses.frame.origin.x + glasses.frame.width + 20
            let distanceLeftToTravel        = fullColorThreshold - -translation
            let distanceTravelled           = fullColorThreshold - distanceLeftToTravel
            let watchBackgroundColorAlpha   = distanceTravelled / fullColorThreshold
            
            let color: UIColor = film?.status.value == nil ? .green : .red
            watchActionView.backgroundColor = color.withAlphaComponent(watchBackgroundColorAlpha)
        case .ended:
            UIView.animate(withDuration: 0.3, animations: {
                self.center = self.originalCenter
            }, completion: { finished in
                guard finished else { return }
                self.removeRatingActionView()
                self.removeWatchActionView()
            })
            
            guard let film = film else { return }
            
            if translation > 0 {
                let rating: Double = stars.reduce(0) { $0 + $1.size.value }
                if rating > 0 { _ = RateFilm(film: film, rating: rating).call().subscribe() }
            } else {
                guard let bgColor = watchActionView?.backgroundColor else { return }
                let alpha = bgColor.cgColor.alpha
                guard alpha >= 1 else { return }
                let action: WatchListAction = film.status.value == nil ? .add : .remove
                _ = AddFilmToWatchList(film: film, action: action).call().subscribe()
            }
        default:
            break
        }
    }
    
    func addWatchActionView() {
        guard self.watchActionView == nil else { return }
        
        let watchActionView = UIView()
        watchActionView.clipsToBounds = true
        watchActionView.backgroundColor = .red
        
        addSubview(watchActionView)
        watchActionView.addSubview(glasses)
        
        watchActionView.easy.layout([
            Leading().to(self, .trailing),
            Top(),
            Height().like(self),
            Width(0)
        ])
        
        glasses.easy.layout([
            Trailing(>=30),
            Leading(30).with(.low),
            Height(50),
            Width(50),
            CenterY()
        ])
        
        self.watchActionView = watchActionView
    }
    
    func removeWatchActionView() {
        guard let watchActionView = watchActionView else { return }
        glasses.removeFromSuperview()
        watchActionView.removeFromSuperview()
        self.watchActionView = nil
    }
    
    func addRatingActionView() {
        guard self.ratingActionView == nil else { return }
        
        let ratingActionView = UIView()
        ratingActionView.clipsToBounds = true
        
        var previousStar: Star?
        for star in stars {
            ratingActionView.addSubview(star)
            
            star.easy.layout([
                CenterY(),
                Size(CGSize(width: 30, height: 30))
            ])
            
            if let previousStar = previousStar {
                star.easy.layout(Leading(15).to(previousStar))
            } else {
                star.easy.layout(Leading(20))
            }
            
            previousStar = star
        }
        
        addSubview(ratingActionView)
        
        ratingActionView.easy.layout([
            Trailing().to(self, .leading),
            Top(),
            Height().like(self),
            Width(0)
        ])
        
        self.ratingActionView = ratingActionView
    }
    
    func removeRatingActionView() {
        guard let ratingActionView = self.ratingActionView else { return }
        
        ratingActionView.removeFromSuperview()
        self.ratingActionView = nil
    }
}

extension FilmTableCell { // UIGestureRecognizerDelegate
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let view = gestureRecognizer.view,
            let pan = gestureRecognizer as? UIPanGestureRecognizer else { return super.gestureRecognizerShouldBegin(gestureRecognizer) }
        let translation = pan.translation(in: view)
        return abs(translation.y) <= abs(translation.x)
    }
}
