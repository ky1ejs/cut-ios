//
//  AuthenticationVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 11/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import RxSwift

class AuthenticationVC: UIViewController {
    let user: User
    let authView = AuthenticationView()
    
    init(user: User) {
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
            
            if safeSelf.authView.mode == .logIn {
                _ = safeSelf.user.login(emailOrUsername: emailOrUsername, password: password)
                    .observeOn(MainScheduler.instance)
                    .subscribe { [weak self] event in
                        guard let safeSelf = self else { return }
                        switch event {
                        case .next:
                            safeSelf.dismiss(animated: true, completion: nil)
                        case .error(let error):
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: ":simple_smile:", style: .default, handler: nil))
                            safeSelf.present(alert, animated: true)
                        case .completed:
                            break
                        }
                }
            } else {
                guard let username = safeSelf.authView.usernameTextField.text else { return }
                _ = safeSelf.user.signUp(email: emailOrUsername, username: username, password: password)
                    .observeOn(MainScheduler.instance)
                    .subscribe { [weak self] event in
                        guard let safeSelf = self else { return }
                        switch event {
                        case .next:
                            safeSelf.dismiss(animated: true, completion: nil)
                        case .error(let error):
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: ":simple_smile:", style: .default, handler: nil))
                            safeSelf.present(alert, animated: true)
                        case .completed:
                            break
                        }
                }
            }
        })
        
        _ = authView.cancelButton.rx.controlEvent(.touchUpInside).takeUntil(rx.deallocated).subscribe(onNext: { _ in
            self.dismiss(animated: true, completion: nil)
        })
    }
}
