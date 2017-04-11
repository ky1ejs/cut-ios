//
//  User.swift
//  Cut
//
//  Created by Kyle McAlpine on 10/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

private typealias Credentials = (email: String, username: String)

class User: JSONDecodeable {
    typealias JsonType = [AnyHashable : Any]
    private let details: Credentials?
    
    var email: String? { return details?.email }
    var username: String? { return details?.username }
    var isFullUser: Bool { return details != nil }
    
    required init(json: JsonType) throws {
        let email = json["email"] as? String
        let username = json["username"] as? String
        
        details = try {
            if let email = email, let username = username {
                return (email, username)
            }

            if email != nil && username == nil || email == nil && username != nil {
                throw ParserError.couldNotParse
            }
            
            return nil
        }()
    }
}
