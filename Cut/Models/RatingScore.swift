//
//  RatingScore.swift
//  Cut
//
//  Created by Kyle McAlpine on 09/05/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

enum RatingScore: Double, RawRepresentable {
    case pointFive = 0.5
    case one = 1
    case onePointFive = 1.5
    case two = 2
    case twoPointFive = 2.5
    case three = 3
    case threePointFive = 3.5
    case four = 4
    case fourPointFive = 4.5
    case five = 5
    
    public typealias RawValue = Double
}
