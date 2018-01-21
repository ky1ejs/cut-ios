//
//  LogIn.swift
//  Cut
//
//  Created by Kyle McAlpine on 25/07/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct LogIn {
    let emailOrUsername: String
    let password: String
}

extension LogIn: Endpoint {
    typealias SuccessData = CurrentUser
    var body: [String : Any] {
        return [
            "email_or_username" : emailOrUsername,
            "password"          : password
        ]
        
    }
    var url: URL { return CutEndpoints.login }
    var method: HTTPMethod { return .post }
    var onSuccess: (SuccessData) -> () {
        return { user in Store.update(user) }
    }
}
