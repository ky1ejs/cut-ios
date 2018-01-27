//
//  GetCurrentUserRatedFilms.swift
//  Cut
//
//  Created by Kyle McAlpine on 17/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct GetCurrentUserRatedFilms {}

extension GetCurrentUserRatedFilms: Endpoint {
    typealias SuccessData = ArrayResponse<Film>
    var url: URL { return CutEndpoints.ratings }
}
