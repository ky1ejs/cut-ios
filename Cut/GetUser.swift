//
//  GetUser.swift
//  Cut
//
//  Created by Kyle McAlpine on 11/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct GetUser {}

extension GetUser: Endpoint {
    typealias SuccessData = User
    var url: URL { return URL(string: "http://localhost:3000/v1/users")! }
}
