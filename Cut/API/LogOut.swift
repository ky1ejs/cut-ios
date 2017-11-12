//
//  LogOut.swift
//  Cut
//
//  Created by Kyle McAlpine on 13/09/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct LogOut {}

extension LogOut: Endpoint {
    typealias SuccessData = User
    var url: URL { return CutEndpoints.logout }
    var method: HTTPMethod { return .post }
    var onSuccess: (User) -> () {
        return { user in Store.update(user) }
    }
}

