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
    weak var delegate: FilmTableCellDelegate?
    
    fileprivate var _textLabel: UILabel
    override var textLabel: UILabel {
        get { return _textLabel }
        set { _textLabel = newValue }
    }
    var posterImageView: UIImageView
    
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
            guard let film = film else {
                textLabel.text = nil
                posterImageView.image = nil
                return
            }
            
            textLabel.text = film.title
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: film.posterURL, placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil, completionHandler: nil)
            backgroundColor = film.status.value == .wantToWatch ? .red : .white
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        _textLabel = UILabel()
        posterImageView = UIImageView()
        
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(textLabel)
        contentView.addSubview(posterImageView)
        
        textLabel <- [
            Leading(30).to(posterImageView),
            CenterY(),
            Bottom(>=20),
            Trailing(5)
        ]
        
        posterImageView <- [
            Top(5),
            CenterY(),
            Leading(5),
            Size(CGSize(width: 61, height: 91))
        ]
        
        panGesture.addTarget(self, action: #selector(pan(gesture:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pan(gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        
        switch gesture.state {
        case .began:
            addRatingActionView()
            addWatchActionView()
            originalCenter = center
        case .changed:
            guard let ratingActionView = ratingActionView else { return }
            guard let watchActionView = watchActionView else { return }
            
            let translation = -gesture.translation(in: view).x
            let starPadding: CGFloat = 30
            for star in stars {
                let starOriginX = translation - star.frame.origin.x
                let halfThreshold = starOriginX - (star.frame.width / 2) + starPadding
                let fullThreshold = starOriginX + starPadding
                
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
            
            center = CGPoint(x: originalCenter.x - translation, y: originalCenter.y)
            
            ratingActionView <- Width(translation)
            
            watchActionView <- Width(-translation)
            
            let fullColorThreshold = glasses.frame.origin.x + glasses.frame.width + 20
            let glassesTranslationDifference = fullColorThreshold - -translation
            let watchBackgroundColorAlpha: CGFloat = glassesTranslationDifference/(fullColorThreshold/100)
            watchActionView.backgroundColor = UIColor.red.withAlphaComponent(watchBackgroundColorAlpha)
        case .ended:
            UIView.animate(withDuration: 0.3, animations: {
                self.center = self.originalCenter
            }, completion: { finished in
                guard finished else { return }
                self.removeRatingActionView()
                self.removeWatchActionView()
            })
            
            
            guard let film = film else { return }
            let rating: Double = stars.reduce(0) { $0 + $1.size.value }
            if rating > 0 { delegate?.rate(film: film, rating: rating) }
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
        
        watchActionView <- [
            Trailing().to(self, .leading),
            Top(),
            Height().like(self),
            Width(0)
        ]
        
        glasses <- [
            Leading(>=30),
            Trailing(30).with(.low),
            Height(50),
            Width(50),
            CenterY()
        ]
        
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
            
            star <- [
                CenterY(),
                Size(CGSize(width: 30, height: 30))
            ]
            
            if let previousStar = previousStar {
                star <- Trailing(15).to(previousStar)
            } else {
                star <- Trailing(20)
            }
            
            previousStar = star
        }
        
        addSubview(ratingActionView)
        
        ratingActionView <- [
            Leading().to(self, .trailing),
            Top(),
            Height().like(self),
            Width(0)
        ]
        
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

protocol FilmTableCellDelegate: class {
    func rate(film: Film, rating: Double)
}
