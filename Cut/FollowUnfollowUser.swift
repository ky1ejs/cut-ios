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
    typealias SuccessData = NoSuccessData
    var url: URL { return URL(string: "http://localhost:3000/v1/users/\(username)")! }
    var method: HTTPMethod { return follow ? .post : .delete }
}
