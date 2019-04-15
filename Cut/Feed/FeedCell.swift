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
            userProfileImageView.kf.setImage(with: watch?.user.userInfo.profileImageURL)
            posterImageView.kf.setImage(with: watch?.film.profileImageURL)
            usernameLabel.text = watch?.user.userInfo.username
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
        
        userProfileImageView.layer.cornerRadius = 15
        userProfileImageView.backgroundColor = .red
        
        posterImageView.backgroundColor = .blue
        
        contentView.addSubview(userProfileImageView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(createdLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(ratingView)
        
        userProfileImageView <- [
            Leading(20),
            Top(10),
            Size(CGSize(width: 30, height: 30))
        ]
        
        usernameLabel <- [
            Leading(10).to(userProfileImageView),
            Bottom().to(userProfileImageView, .bottom)
        ]
        
        createdLabel <- [
            Bottom().to(userProfileImageView, .bottom),
            Trailing(20)
        ]
        
        titleLabel <- [
            Leading().to(userProfileImageView, .leading),
            Top(20).to(userProfileImageView),
        ]
        
        bodyLabel <- [
            Leading().to(userProfileImageView, .leading),
            Top(10).to(titleLabel)
        ]
        
        ratingView <- [
            Top(10).to(bodyLabel),
            Leading().to(bodyLabel, .leading)
        ]
        
        let posterWidth: CGFloat = 100
        posterImageView <- [
            Leading(30).to(titleLabel),
            Trailing().to(createdLabel, .trailing),
            Top().to(userProfileImageView, .top),
            Width(100),
            Height(posterWidth * .posterWidthToHeightRation),
            CenterY().with(.medium)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
