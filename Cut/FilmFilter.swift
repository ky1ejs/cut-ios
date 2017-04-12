//
//  FilmFilter.swift
//  Cut
//
//  Created by Kyle McAlpine on 11/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

enum FilmFilter: String {
    case popular = "popular"
    case topBoxOffice = "top-box-office"
    case upcoming = "theater-upcoming"
    case newDvdReleases = "new-release-dvds"
}

extension FilmFilter: CustomStringConvertible {
    var description: String {
        switch self {
        case .popular:          return "In Theaters"
        case .topBoxOffice:     return "Top Box Office"
        case .upcoming:         return "Upcoming"
        case .newDvdReleases:   return "DVDs"
        }
    }
}
