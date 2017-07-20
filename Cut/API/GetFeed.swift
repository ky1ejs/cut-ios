//
//  GetFeed.swift
//  Cut
//
//  Created by Kyle McAlpine on 20/07/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct GetFeed {}

extension GetFeed: Endpoint {
    typealias SuccessData = ArrayResponse<Watch>
    var url: URL { return CutEndpoints.feed }
}
