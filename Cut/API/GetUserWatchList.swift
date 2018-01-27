//
//  GetUserWatchList.swift
//  Cut
//
//  Created by Kyle McAlpine on 25/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import Foundation

struct GetUserWatchList {
    let username: String
}

extension GetUserWatchList: Endpoint {
    typealias SuccessData = ArrayResponse<Film>
    var url: URL { return CutEndpoints.users.appendingPathComponent("\(username)/watch-list") }
}
