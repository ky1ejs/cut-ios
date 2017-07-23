//
//  Watch.swift
//  Cut
//
//  Created by Kyle McAlpine on 20/07/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct Watch {
    let user: User
    let film: Film
    let rating: StarRating?
    let comment: String?
    
    var watched: Bool {
        return rating != nil || comment != nil
    }
}

extension Watch: JSONDecodeable {
    typealias JsonType = [AnyHashable : Any]
    
    init(json: JsonType) throws {
        user = try User(json: try json.parseDict(key: "user"))
        film = try Film(json: try json.parseDict(key: "film"))
        rating = StarRating(rawValue: try json.parse(key: "rating"))
        comment = try json.parse(key: "comment")
    }
}
