//
//  GetFollowers.swift
//  Cut
//
//  Created by Kyle McAlpine on 29/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import Foundation

struct GetFollowers {
    let user: User
}

extension GetFollowers: Endpoint {
    typealias SuccessData = ArrayResponse<User>
    var url: URL { return CutEndpoints.users.appendingPathComponent("\(user.username)/followers") }
}
