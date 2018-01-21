//
//  UserCell.swift
//  Cut
//
//  Created by Kyle McAlpine on 14/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy
import Kingfisher

class UserCell: UITableViewCell {
    var user: CurrentUser? {
        didSet {
            profileImageView.kf.setImage(with: user?.profileImageURL)
            usernameTitleLabel.text = user?.username.value
            _ = user?.following.asObservable().subscribe(onNext: { following in
                self.followButton.setTitle(following ? "Unfollow" : "Follow", for: .normal)
            })
        }
    }
    
    let profileImageView = UIImageView()
    let usernameTitleLabel = UILabel()
    let followButton = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameTitleLabel)
        contentView.addSubview(followButton)
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(.blue, for: .normal)
        followButton.layer.borderColor = UIColor.blue.cgColor
        followButton.layer.borderWidth = 2
        followButton.layer.cornerRadius = 5
        
        profileImageView <- [
            Leading(20),
            CenterY(),
            Top(>=20),
            Height(40),
            Width().like(profileImageView, .height)
        ]
        
        usernameTitleLabel <- [
            Leading(15).to(profileImageView),
            CenterY(),
            Top(>=20)
        ]
        
        followButton <- [
            CenterY(),
            Leading(15).to(usernameTitleLabel),
            Trailing(20),
            Height(34),
            Width(80)
        ]
        
        _ = followButton.rx.tap.takeUntil(rx.deallocated).subscribe(onNext: { _ in
            _ = self.user?.toggleFollowing().subscribe()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
