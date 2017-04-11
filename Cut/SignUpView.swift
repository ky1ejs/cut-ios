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
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let emailTextField = UITextField()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let signUpButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
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
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.blue, for: .normal)
        
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
        
        textFieldCenteringContainer.addSubview(emailTextField)
        textFieldCenteringContainer.addSubview(usernameTextField)
        textFieldCenteringContainer.addSubview(passwordTextField)
        textFieldCenteringContainer.addSubview(signUpButton)
        
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
        
        emailTextField <- [
            Top(),
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
        
        signUpButton <- [
            Top(20).to(passwordTextField),
            Leading().to(passwordTextField, .leading),
            CenterX(),
            Bottom()
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
