//
//  ProfileView.swift
//  Cut
//
//  Created by Kyle McAlpine on 10/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    var user: User? {
        didSet {
            guard user?.isFullUser == true else { return }
            emailLabel.text = user?.email
            usernameLabel.text = user?.username
        }
    }
    
    private let emailLabel = UILabel()
    private let usernameLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
