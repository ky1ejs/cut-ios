//
//  CurrentSignedUpUser.swift
//  Cut
//
//  Created by Kyle McAlpine on 15/03/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import Foundation
import RocketData

struct CurrentSignedUpUser {
    let email: String
    let info: SignedUpUserInfo
}

extension CurrentSignedUpUser: JSONDecodeable {
    typealias JsonType = [AnyHashable : Any]
    
    init(json: JsonType) throws {
        email = try json.parse(key: "email")
        info = try SignedUpUserInfo(json: json)
    }
}

extension CurrentSignedUpUser: Model {
    var modelIdentifier: String? { return info.id }
    func map(_ transform: (Model) -> Model?) -> CurrentSignedUpUser? { return self }
    func forEach(_ visit: (Model) -> Void) {}
}

extension CurrentSignedUpUser: AutoEquatable {}
