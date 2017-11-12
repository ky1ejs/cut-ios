//
//  FeedIntroView.swift
//  Cut
//
//  Created by Kyle McAlpine on 06/11/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

enum FeedIntroViewMode {
    case loginSignUp
    case followFriends
    
    var body: String {
        switch self {
        case .loginSignUp:
            return "Login or sign up to follow friends and see when they rate films or add them to their watch list."
        case .followFriends:
            return "Follow some friends to see the films their interested in"
        }
    }
    
    var cta: String {
        switch self {
        case .loginSignUp:
            return "Login or Sign Up"
        case .followFriends:
            return "Follow Friends"
        }
    }
}

class FeedIntroView: UIView {
    init(mode: FeedIntroViewMode) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        let bodyLabel = UILabel()
        bodyLabel.text = mode.body
        bodyLabel.numberOfLines = 0
        bodyLabel.textAlignment = .center
        
        let ctaButton = UIButton(type: .custom)
        ctaButton.setTitle(mode.cta, for: .normal)
        ctaButton.setTitleColor(.white, for: .normal)
        ctaButton.backgroundColor = .red
        ctaButton.layer.cornerRadius = 5
            
        addSubview(bodyLabel)
        addSubview(ctaButton)
        
        bodyLabel <- [
            Leading(20),
            CenterX(),
            CenterY()
        ]
        
        ctaButton <- [
            Top(20).to(bodyLabel),
            CenterX(),
            Leading(50),
            Height(44)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
