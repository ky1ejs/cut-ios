//
//  RatingSource.swift
//  Cut
//
//  Created by Kyle McAlpine on 09/05/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

enum RatingSource: String, JSONDecodeable {
    case cutUsers = "cut_users"
    case imdbUsers = "imdb_users"
    case rottenTomatoes = "rotten_tomatoes"
    case flixsterUsers = "flixster_users"
    
    static var all: [RatingSource] { return [.cutUsers, .rottenTomatoes, .flixsterUsers, .imdbUsers] }
}

extension RatingSource {
    var icon: UIImage {
        switch self {
        case .cutUsers:         return R.image.cutRating()!
        case .imdbUsers:        return R.image.popcorn()!
        case .rottenTomatoes:   return R.image.tomato()!
        case .flixsterUsers:    return R.image.popcorn()!
        }
    }
}
