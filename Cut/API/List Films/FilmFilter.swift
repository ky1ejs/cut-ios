//
//  FilmFilter.swift
//  Cut
//
//  Created by Kyle McAlpine on 11/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

enum FilmFilter: String {
    case inTheaters         = "in-theaters"
    case releasingSoon      = "releasing-soon"
    case hotRightNow        = "hot-right-now"
    case newStoreReleases   = "new-store-releases"
    case topRatedAllTime    = "top-rated-all-time"
}

extension FilmFilter: CustomStringConvertible {
    var description: String {
        switch self {
        case .inTheaters:       return "In Theaters"
        case .releasingSoon:    return "Releasing Soon"
        case .hotRightNow:      return "Hot Right Now"
        case .newStoreReleases: return "New Store Releases"
        case .topRatedAllTime:  return "Top Rated All Time"
        }
    }
}
