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
    var user: User? {
        didSet {
            profileImageView.kf.setImage(with: user?.profileImageURL)
            usernameTitleLabel.text = user?.username.value
        }
    }
    
    let profileImageView = UIImageView()
    let usernameTitleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameTitleLabel)
        
        profileImageView.layer.cornerRadius = 5
        
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
            Top(>=20),
            Trailing(20)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
