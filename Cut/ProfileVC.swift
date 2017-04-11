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
    var user: User? {
        didSet {
            _ = user?.username
                .asObservable()
                .takeUntil(rx.deallocated)
                .bindTo(profileView.usernameLabel.rx.text)
            _ = user?.email
                .asObservable()
                .takeUntil(rx.deallocated)
                .bindTo(profileView.emailLabel.rx.text)
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = GetUser().call().observeOn(MainScheduler.instance).subscribe { [weak self] event in
            switch event {
            case .next(let user):
                self?.user = user
                if !user.isFullUser {
                    print(Thread.current.isMainThread)
                    self?.present(SignUpVC(user: user), animated: true)
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
