//
//  GetCurrentUser.swift
//  Cut
//
//  Created by Kyle McAlpine on 11/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct GetCurrentUser {}

extension GetCurrentUser: Endpoint {
    typealias SuccessData = EitherCurrentUser
    var url: URL { return CutEndpoints.base }
    
}
