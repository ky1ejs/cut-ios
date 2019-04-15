//
//  FIlmStatus.swift
//  Cut
//
//  Created by Kyle McAlpine on 09/05/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

enum FilmStatus: JSONDecodeable {
    case wantToWatch
    case rated(StarRating)
    
    init(from decoder: Decoder) throws {
        
    }
    
    var ratingScore: StarRating? {
        switch self {
        case .rated(let score): return score
        default:                return nil
        }
    }
}

extension FilmStatus: AutoEquatable {}
