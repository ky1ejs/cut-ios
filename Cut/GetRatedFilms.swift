//
//  GetRatedFilms.swift
//  Cut
//
//  Created by Kyle McAlpine on 17/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct GetRatedFilms {}

extension GetRatedFilms: Endpoint {
    typealias SuccessData = ArrayResponse<Film>
    var url: URL { return URL(string: "http://localhost:3000/v1/ratings")! }
}
