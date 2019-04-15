//
//  Watch.swift
//  Cut
//
//  Created by Kyle McAlpine on 20/07/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation
import RocketData

struct Watch {
    let id: String
    let user: EitherSignedUpUser
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
        id = try json.parse(key: "id")
        user = try EitherSignedUpUser(json: json)
        film = try Film(json: try json.parseDict(key: "film"))
        if let ratingValue = json["rating"] as? Double {
            rating = StarRating(rawValue: ratingValue)
        } else {
            rating = nil
        }
        comment = json["comment"] as? String
    }
}

extension Watch: Model {
    var modelIdentifier: String? { return id }
    func map(_ transform: (Model) -> Model?) -> Watch? {
        guard let user = transform(user) as? EitherSignedUpUser else { return nil }
        guard let film = transform(film) as? Film else { return nil }
        return Watch(id: id, user: user, film: film, rating: rating, comment: comment)
    }
    func forEach(_ visit: (Model) -> Void) {
        visit(user)
        visit(film)
    }
}

extension Watch: AutoEquatable {}
