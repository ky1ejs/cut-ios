//
//  SignUpView.swift
//  Cut
//
//  Created by Kyle McAlpine on 11/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

class SignUpView: UIView {
    let segmentedControl    = UISegmentedControl(items: ["Sign Up", "Log In"])
    let titleLabel          = UILabel()
    let descriptionLabel    = UILabel()
    let emailTextField      = UITextField()
    let usernameTextField   = UITextField()
    let passwordTextField   = UITextField()
    let actionButton        = UIButton()
    
    var mode: SignUpMode = .signUp {
        didSet {
            passwordTextField <- Top(20).to(mode == .signUp ? usernameTextField : emailTextField)
            actionButton.setTitle(mode.title, for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.usernameTextField.alpha = self.mode == .signUp ? 1 : 0
                self.layoutIfNeeded()
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(changeMethod), for: .valueChanged)
        
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.spellCheckingType = .no
        emailTextField.autocapitalizationType = .none
        
        usernameTextField.placeholder = "Username"
        usernameTextField.autocorrectionType = .no
        usernameTextField.spellCheckingType = .no
        usernameTextField.autocapitalizationType = .none
        
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        actionButton.setTitle("Sign Up", for: .normal)
        actionButton.setTitleColor(.blue, for: .normal)
        
        let titleDescriptionContainer = UIView()
        let textFieldContainer = UIView()
        
        let titleCenteringContainer = UIView()
        let textFieldCenteringContainer = UIView()
        
        addSubview(titleDescriptionContainer)
        addSubview(textFieldContainer)
        
        titleDescriptionContainer.addSubview(titleCenteringContainer)
        textFieldContainer.addSubview(textFieldCenteringContainer)
        
        titleCenteringContainer.addSubview(titleLabel)
        titleCenteringContainer.addSubview(descriptionLabel)
        
        textFieldCenteringContainer.addSubview(segmentedControl)
        textFieldCenteringContainer.addSubview(emailTextField)
        textFieldCenteringContainer.addSubview(usernameTextField)
        textFieldCenteringContainer.addSubview(passwordTextField)
        textFieldCenteringContainer.addSubview(actionButton)
        
        titleDescriptionContainer <- [
            Top(),
            Leading(),
            CenterX(),
            Height(*0.35)
        ]
        
        textFieldContainer <- [
            Top().to(titleDescriptionContainer),
            Leading(),
            CenterX(),
            Bottom()
        ]
        
        titleCenteringContainer <- [
            Leading(30),
            CenterX(),
            CenterY()
        ]
        
        textFieldCenteringContainer <- [
            Leading(30),
            CenterX(),
            CenterY()
        ]
        
        titleLabel <- [
            Top(),
            Leading(),
            CenterX()
        ]
        
        descriptionLabel <- [
            Top(10).to(titleCenteringContainer),
            Leading().to(titleLabel, .leading),
            CenterX(),
            Bottom()
        ]
        
        segmentedControl <- [
            Top(),
            CenterX()
        ]
        
        emailTextField <- [
            Top(30).to(segmentedControl),
            Leading(30),
            CenterX(),
        ]
        
        usernameTextField <- [
            Top(20).to(emailTextField),
            Leading().to(emailTextField, .leading),
            CenterX()
        ]
        
        passwordTextField <- [
            Top(20).to(usernameTextField),
            Leading().to(usernameTextField, .leading),
            CenterX()
        ]
        
        actionButton <- [
            Top(20).to(passwordTextField),
            Leading().to(passwordTextField, .leading),
            CenterX(),
            Bottom()
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changeMethod() {
        guard let mode = SignUpMode(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        self.mode = mode
    }
}

enum SignUpMode: Int {
    case signUp = 0
    case logIn = 1
    
    var title: String {
        switch self {
        case .signUp:   return "Sign Up"
        case .logIn:    return "Log In"
        }
    }
}
