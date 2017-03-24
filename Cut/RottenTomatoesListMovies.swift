//
//  RottenTomatoesListMovies.swift
//  Cut
//
//  Created by Kyle McAlpine on 22/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct RottenTomatoesListMovies {
    
}

extension RottenTomatoesListMovies: Endpoint {
    typealias Parser = RottenTomatoesMoviesParser
    var url: URL { return URL(string: "https://api.flixster.com/iphone/api/v2/movies.json")! }
    var urlParams: [String : String] {
        return [
            "cbr" : "1",
            "country" : "UK",
            "deviceType" : "iPhone",
            "filter" : "theater-upcoming",
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

