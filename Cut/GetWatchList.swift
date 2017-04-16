//
//  GetWatchList.swift
//  Cut
//
//  Created by Kyle McAlpine on 16/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct GetWatchList {}

extension GetWatchList: Endpoint {
    typealias SuccessData = ArrayResponse<Film>
    var url: URL { return URL(string: "http://localhost:3000/v1/watch-list")! }
}
