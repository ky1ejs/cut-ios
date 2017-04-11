//
//  ProfileView.swift
//  Cut
//
//  Created by Kyle McAlpine on 10/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

class ProfileView: UIView {
    let emailLabel = UILabel()
    let usernameLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        let centeringContainer = UIView()
        
        addSubview(centeringContainer)
        centeringContainer.addSubview(emailLabel)
        centeringContainer.addSubview(usernameLabel)
        
        centeringContainer <- [
            Leading(),
            CenterX(),
            CenterY()
        ]
        
        emailLabel <- [
            Leading(30),
            Top(),
            CenterX()
        ]
        
        usernameLabel <- [
            Leading().to(emailLabel, .leading),
            Top(10).to(emailLabel),
            Bottom()
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
