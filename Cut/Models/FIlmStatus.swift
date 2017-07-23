//
//  FIlmStatus.swift
//  Cut
//
//  Created by Kyle McAlpine on 09/05/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

enum FilmStatus {
    case wantToWatch
    case rated(StarRating)
    
    var ratingScore: StarRating? {
        switch self {
        case .rated(let score): return score
        default:                return nil
        }
    }
}

extension FilmStatus: Equatable {}
func ==(lhs: FilmStatus, rhs: FilmStatus) -> Bool {
    switch (lhs, rhs) {
    case (.wantToWatch, .wantToWatch): return true
    case let (.rated(lhsRating), .rated(rhsRating)): return lhsRating == rhsRating
    default: return false
    }
}
