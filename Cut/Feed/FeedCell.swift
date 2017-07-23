//
//  FeedCell.swift
//  Cut
//
//  Created by Kyle McAlpine on 20/07/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

class FeedCell: UITableViewCell {
    var watch: Watch? {
        didSet {
            userProfileImageView.kf.setImage(with: watch?.user.profileImageURL)
            posterImageView.kf.setImage(with: watch?.film.profileImageURL)
            usernameLabel.text = watch?.user.username.value
            titleLabel.text = watch?.film.title
            
            bodyLabel.text = watch?.watched == .some(true) ? "Watched" : "Added to watch list"
            ratingView.rating = watch?.rating
        }
    }
    
    private let userProfileImageView = UIImageView()
    private let posterImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let titleLabel = UILabel()
    private let createdLabel = UILabel()
    private let bodyLabel = UILabel()
    private let ratingView = StarRatingView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userProfileImageView.layer.cornerRadius = 25
        
        addSubview(userProfileImageView)
        addSubview(posterImageView)
        addSubview(usernameLabel)
        addSubview(titleLabel)
        addSubview(createdLabel)
        addSubview(bodyLabel)
        addSubview(ratingView)
        
        userProfileImageView <- [
            Leading(40).to(posterImageView),
            Top().to(posterImageView, .top),
            Size(CGSize(width: 50, height: 50))
        ]
        
        posterImageView <- [
            Leading(30),
            CenterY(),
            Bottom(20),
            Width(100),
            Height(*CGFloat.posterWidthToHeightRation).like(posterImageView, .width)
        ]
        
        usernameLabel <- [
            Leading(10).to(userProfileImageView),
            Bottom().to(userProfileImageView, .bottom)
        ]
        
        titleLabel <- [
        ]
        
        bodyLabel <- [
            Leading().to(userProfileImageView, .leading),
            Top(30).to(userProfileImageView)
        ]
        
        createdLabel <- [
            Top(20).to(bodyLabel),
            Leading().to(bodyLabel, .leading)
        ]
        
        ratingView <- [
            Top(20).to(createdLabel),
            Leading().to(createdLabel, .leading)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
