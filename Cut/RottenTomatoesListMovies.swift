//
//  RottenTomatoesListMovies.swift
//  Cut
//
//  Created by Kyle McAlpine on 22/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

enum RottenTomatoesMovieFilter: String {
    case popular = "popular"
    case topBoxOffice = "top-box-office"
    case upcoming = "theater-upcoming"
    case newDvdReleases = "new-release-dvds"
}

extension RottenTomatoesMovieFilter: CustomStringConvertible {
    var description: String {
        switch self {
        case .popular:          return "In Theaters"
        case .topBoxOffice:     return "Top Box Office"
        case .upcoming:         return "Upcoming"
        case .newDvdReleases:   return "DVDs"
        }
    }
}

struct RottenTomatoesListMovies {
    var filter: RottenTomatoesMovieFilter
}

extension RottenTomatoesListMovies: Endpoint {
    typealias Parser = RottenTomatoesMoviesParser
    var url: URL { return URL(string: "https://api.flixster.com/iphone/api/v2/movies.json")! }
    var urlParams: [String : String] {
        return [
            "cbr" : "1",
            "country" : "UK",
            "deviceType" : "iPhone",
            "filter" : filter.rawValue,
            "limit" : "100",
            "locale" : "en_GB",
            "version" : "7.13.3",
            "view" : "long"
        ]
    }
}

struct RottenTomatoesMovieParser: JSONParser {
    typealias JsonType = [AnyHashable : Any]
    typealias ParsedType = Movie
    static func parse(json: JsonType) throws -> Movie {
        let id: Int = try json.parse(key: "id")
        let title: String = try json.parse(key: "title")
        let posterUrlString: String = try (json.parse(key: "poster") as [String : String]).parse(key: "thumbnail")
        guard let posterURL = URL(string: posterUrlString) else { throw ParserError.couldNotParse }
        return Movie(id: id, title: title, posterURL: posterURL, status: nil)
    }
}

struct RottenTomatoesMoviesParser: JSONParser {
    typealias JsonType = [[AnyHashable : Any]]
    typealias ParsedType = [Movie]
    static func parse(json: JsonType) throws -> Array<Movie> {
        return json.flatMap() { try? RottenTomatoesMovieParser.parse(json: $0) }
    }
}

