//
//  Movie.swift
//  Cut
//
//  Created by Kyle McAlpine on 03/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct Movie {
    let id: Int
    let title: String
    let status: MovieStatus?
}

enum MovieStatus {
    case wantToSee
    case watched(Rating?)
}

enum Rating: Int {
    case one
    case two
    case three
    case four
    case five
}
