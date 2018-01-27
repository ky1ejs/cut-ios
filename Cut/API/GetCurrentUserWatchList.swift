//
//  GetCurrentUserWatchList.swift
//  Cut
//
//  Created by Kyle McAlpine on 16/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct GetCurrentUserWatchList {}

extension GetCurrentUserWatchList: Endpoint {
    typealias SuccessData = ArrayResponse<Film>
    var url: URL { return CutEndpoints.watchList }
}
