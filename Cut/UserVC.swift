//
//  UserVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 21/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import UIKit

class UserVC: UIViewController {
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
