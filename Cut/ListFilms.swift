//
//  ListFilms.swift
//  Cut
//
//  Created by Kyle McAlpine on 22/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

struct ListFilms {}

extension ListFilms: Endpoint {
    typealias SuccessData = ArrayResponse<Film>
    var url: URL { return CutEndpoints.films }
}
