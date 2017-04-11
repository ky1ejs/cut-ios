//
//  ProfileVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 10/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy
import RxSwift

class ProfileVC: UIViewController {
    let profileView = ProfileView()
    let signUpView = SignUpView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = profileView
        
        view.addSubview(signUpView)
        signUpView.alpha = 0
        signUpView <- Edges()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = GetUser().call().observeOn(MainScheduler.instance).subscribe { [weak self] event in
            switch event {
            case .next(let user):
                if user.isFullUser {
                    self?.profileView.user = user
                } else {
                    print(Thread.current.isMainThread)
                    self?.signUpView.alpha = 1
                }
            case .error(let error):
                print(error)
            case .completed:
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
