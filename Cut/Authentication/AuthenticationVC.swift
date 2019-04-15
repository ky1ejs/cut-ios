//
//  AuthenticationVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 11/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import RxSwift
import RocketData

class AuthenticationVC: UIViewController {
    let user: CurrentUser
    let authView = AuthenticationView()
    
    init(user: CurrentUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = authView.actionButton.rx.tap.takeUntil(rx.deallocated).subscribe(onNext: { [weak self] _ in
            guard let safeSelf = self else { return }
            
            guard let emailOrUsername = safeSelf.authView.emailTextField.text,
            let password = safeSelf.authView.passwordTextField.text else {
                    return
            }
            
            let handleAuth: (Event<CurrentSignedUpUser>) -> () = { [weak self] event in
                guard let safeSelf = self else { return }
                switch event {
                case .next(let user):
                    DataModelManager.sharedInstance.consistencyManager.updateModel(user)
                    safeSelf.dismiss(animated: true, completion: nil)
                case .error(let error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: ":simple_smile:", style: .default, handler: nil))
                    safeSelf.present(alert, animated: true)
                case .completed:
                    break
                }
            }
            
            if safeSelf.authView.mode == .logIn {
                _ = LogIn(emailOrUsername: emailOrUsername, password: password).call().observeOn(MainScheduler.instance).subscribe(handleAuth)
            } else {
                guard let username = safeSelf.authView.usernameTextField.text else { return }
                _ = SignUp(email: emailOrUsername, username: username, password: password).call().observeOn(MainScheduler.instance).subscribe(handleAuth)
            }
        })
        
        _ = authView.cancelButton.rx.controlEvent(.touchUpInside).takeUntil(rx.deallocated).subscribe(onNext: { _ in
            self.dismiss(animated: true, completion: nil)
        })
    }
}
