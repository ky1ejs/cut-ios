//
//  GetUser.swift
//  Cut
//
//  Created by Kyle McAlpine on 27/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import Foundation

struct GetUser {
    let username: String
}

extension GetUser: Endpoint {
    typealias SuccessData = User
    var url: URL { return CutEndpoints.users.appendingPathComponent(username) }
}

