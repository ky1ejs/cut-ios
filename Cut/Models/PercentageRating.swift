//
//  PercentageRating.swift
//  Cut
//
//  Created by Kyle McAlpine on 09/05/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

struct PercentageRating: JSONDecodeable {
    let source: RatingSource
    let score: Double
    let count: Int?
    
    var icon: UIImage {
        switch source {
        case .rottenTomatoes:
            if score < 0.6 {
                return R.image.rottenTomato()!
            } else if let count = count, count >= 50 {
                return R.image.freshTomato()!
            }
            return R.image.tomato()!
        default:
            return source.icon
        }
    }
}

extension PercentageRating: AutoEquatable {}
