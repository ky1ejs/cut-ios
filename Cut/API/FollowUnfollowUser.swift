//
//  FollowUnfollowUser.swift
//  Cut
//
//  Created by Kyle McAlpine on 14/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct FollowUnfollowUser {
    let username: String
    let follow: Bool
}

extension FollowUnfollowUser: Endpoint {
    typealias SuccessData = User
    var url: URL { return CutEndpoints.users.appendingPathComponent(username) }
    var method: HTTPMethod { return follow ? .post : .delete }
}
