//
//  EitherSignedUpUser.swift
//  Cut
//
//  Created by Kyle McAlpine on 30/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import Foundation
import RocketData

enum EitherSignedUpUser {
    case currentUser(CurrentSignedUpUser)
    case user(User)
    
    var userInfo: SignedUpUserInfo {
        switch self {
        case .currentUser(let user):    return user.info
        case .user(let user):           return user.info
        }
    }
    
    private var model: Model {
        switch self {
        case .currentUser(let user):    return user
        case .user(let user):           return user
        }
    }
}

extension EitherSignedUpUser: JSONDecodeable {
    typealias JsonType = [AnyHashable : Any]
    
    init(json: JsonType) throws {
        if json["email"] as? String != nil {
            self = .currentUser(try CurrentSignedUpUser(json: json))
        } else {
            self = .user(try User(json: json))
        }
    }
}

extension EitherSignedUpUser: Model {
    var modelIdentifier: String? { return userInfo.id }
    
    func map(_ transform: (Model) -> Model?) -> EitherSignedUpUser? {
        let model = transform(self.model)
        
        if let currentUser = model as? CurrentSignedUpUser {
            return .currentUser(currentUser)
        } else if let user = model as? User {
            return .user(user)
        } else {
            return nil
        }
    }
    
    func forEach(_ visit: (Model) -> Void) {
        visit(model)
    }
}

extension EitherSignedUpUser: AutoEquatable {}
