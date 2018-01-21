//
//  SignUp.swift
//  Cut
//
//  Created by Kyle McAlpine on 11/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct SignUp {
    var email: String
    var username: String
    var password: String
}

extension SignUp: Endpoint {
    typealias SuccessData = CurrentUser
    var url: URL { return CutEndpoints.signUp }
    var body: [String : Any] {
        return [
            "email" : email,
            "username" : username,
            "password" : password
        ]
    }
    var method: HTTPMethod { return .post }
}
