//
//  Search.swift
//  Cut
//
//  Created by Kyle McAlpine on 13/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct Search {
    let term: String
}

extension Search: Endpoint {
    typealias SuccessData = SearchResults
    var url: URL { return CutEndpoints.search }
    var urlParams: [String : String] { return ["term" : term] }
}

struct SearchResults {
    let films: [Film]
    let users: [CurrentUser]
}

extension SearchResults: JSONDecodeable {
    typealias JsonType = [String : Any]
    init(json: JsonType) throws {
        let filmsJson: [[String : Any]] = try json.parse(key: "films")
        let films = try ArrayResponse<Film>(json: filmsJson)
        self.films = films.models
        
        let usersJson: [[AnyHashable : Any]] = try json.parse(key: "users")
        let users = try ArrayResponse<CurrentUser>(json: usersJson)
        self.users = users.models
    }
}
