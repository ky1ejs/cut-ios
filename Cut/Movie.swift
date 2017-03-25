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
    let posterURL: URL
    fileprivate(set) var status: MovieStatus?
    
    mutating func addToWatchList() {
        guard status != .wantToWatch else { return }
        status = .wantToWatch
    }
}

enum MovieStatus {
    case wantToWatch
    case watched(Rating?)
}

extension MovieStatus: Equatable {}
func ==(lhs: MovieStatus, rhs: MovieStatus) -> Bool {
    switch (lhs, rhs) {
    case (.wantToWatch, .wantToWatch): return true
    case let (.watched(lhsRating), .watched(rhsRating)): return lhsRating == rhsRating
    default: return false
    }
}

enum Rating: Int {
    case one
    case two
    case three
    case four
    case five
}
