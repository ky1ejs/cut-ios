//
//  ListFilms.swift
//  Cut
//
//  Created by Kyle McAlpine on 22/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

struct ListFilms {
    let filter: FilmFilter
    init()                      { filter = .inTheaters }
    init(filter: FilmFilter)    { self.filter = filter }
}

extension ListFilms: Endpoint {
    typealias SuccessData = Array<Film>
    var urlParams: [String : String] { return ["filter" : filter.rawValue] }
    var url: URL { return CutEndpoints.films }
}
