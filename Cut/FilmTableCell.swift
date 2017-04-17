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
    var posterImageView: UIImageView
    
    let panGesture = UIPanGestureRecognizer()
    var originalCenter = CGPoint.zero
    
    let stars: [Star] = {
        return (0..<5).map() { _ in Star(size: .full) }
    }()
    
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
            backgroundColor = film.status == .wantToWatch ? .red : .white
        }
    }
    
    var starContainer: UIView?
    
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
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pan(gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        
        switch gesture.state {
        case .began:
            addStars()
            originalCenter = center
        case .changed:
            guard let starContainer = starContainer else { return }
            let translation = -gesture.translation(in: view).x
            let starPadding: CGFloat = 20
            for star in stars {
                let starOriginX = translation - star.frame.origin.x
                let halfThreshold = starOriginX - (star.frame.width / 2) + starPadding
                let fullThreshold = starOriginX + starPadding
                
                print(halfThreshold)
                print(fullThreshold)
                
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
                
                print(star.size)
            }
            center = CGPoint(x: originalCenter.x - translation, y: originalCenter.y)
            starContainer <- Width(translation)
        case .ended:
            UIView.animate(withDuration: 0.3, animations: {
                self.center = self.originalCenter
            }, completion: { finished in
                guard finished else { return }
                self.removeStars()
            })
        default:
            break
        }
    }
    
    func addStars() {
        guard self.starContainer == nil else { return }
        
        let starContainer = UIView()
        starContainer.clipsToBounds = true
        
        var previousStar: Star?
        for star in stars {
            starContainer.addSubview(star)
            
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
        
        addSubview(starContainer)
        
        starContainer <- [
            Leading().to(self, .trailing),
            Top(),
            Height().like(self),
            Width(0)
        ]
        
        self.starContainer = starContainer
    }
    
    func removeStars() {
        guard let starContainer = self.starContainer else { return }
        
        starContainer.removeFromSuperview()
        self.starContainer = nil
    }
}
