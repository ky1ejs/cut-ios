//
//  UserView.swift
//  Cut
//
//  Created by Kyle McAlpine on 21/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import UIKit

class UserView: UIView {
    let usernameLabel = UILabel()
    let followerCountLabel = UILabel()
    let followingCountLabel = UILabel()
    let followButton = UIButton()
    let segmentedControl = UISegmentedControl(items: ["Watch List", "Ratings"])
    
    init(user: User) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
