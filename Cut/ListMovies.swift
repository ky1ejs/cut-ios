//
//  RottenTomatoesListMovies.swift
//  Cut
//
//  Created by Kyle McAlpine on 22/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

struct ListMovies {}

extension ListMovies: Endpoint {
    typealias SuccessData = ArrayResponse<Movie>
    var url: URL { return URL(string: "http://localhost:3000/v1/films")! }
}
