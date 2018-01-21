//
//  Watch.swift
//  Cut
//
//  Created by Kyle McAlpine on 20/07/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct Watch {
    let user: CurrentUser
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
        user = try CurrentUser(json: try json.parseDict(key: "user"))
        film = try Film(json: try json.parseDict(key: "film"))
        if let ratingValue = json["rating"] as? Double {
            rating = StarRating(rawValue: ratingValue)
        } else {
            rating = nil
        }
        comment = json["comment"] as? String
    }
}
