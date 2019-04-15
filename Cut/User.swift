//
//  User.swift
//  Cut
//
//  Created by Kyle McAlpine on 21/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import Foundation
import RocketData

struct User {
    let info: SignedUpUserInfo
    let following: Bool
}

extension User: JSONDecodeable {
    typealias JsonType = [AnyHashable : Any]
    
    init(json: JsonType) throws {
        info = try SignedUpUserInfo(json: json)
        following = try json.parse(key: "following")
    }
}

extension User: Model {
    var modelIdentifier: String? { return info.id }
    func map(_ transform: (Model) -> Model?) -> User? { return self }
    func forEach(_ visit: (Model) -> Void) {}
}

extension User: AutoEquatable {}
