//
//  EitherCurrentUser.swift
//  Cut
//
//  Created by Kyle McAlpine on 16/03/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import Foundation
import RocketData

enum EitherCurrentUser {
    case currentUser(CurrentUser)
    case currentSignedUpUser(CurrentSignedUpUser)
    
    var basicInfo: BasicUserInfo {
        switch self {
        case .currentUser(let user):
            return user.info
        case .currentSignedUpUser(let user):
            return BasicUserInfo(id: user.info.id, watchListCount: user.info.watchListCount, ratedCount: user.info.ratedCount)
        }
    }
    
    var signedUpInfo: SignedUpUserInfo? {
        switch self {
        case .currentUser:                      return nil
        case .currentSignedUpUser(let user):    return user.info
        }
    }
    
    private var model: Model {
        switch self {
        case .currentUser(let user):            return user
        case .currentSignedUpUser(let user):    return user
        }
    }
}

extension EitherCurrentUser: CustomJSONDecodable {
    typealias JsonType = [AnyHashable : Any]
    
    init(json: JsonType) throws {
        if json["email"] as? String != nil {
            self = .currentSignedUpUser(try CurrentSignedUpUser(json: json))
        } else {
            self = .currentUser(try CurrentUser(json: json))
        }
    }
}

extension EitherCurrentUser: Model {
    var modelIdentifier: String? { return basicInfo.id }
    
    func map(_ transform: (Model) -> Model?) -> EitherCurrentUser? {
        let model = transform(self.model)
        
        if let currentUser = model as? CurrentUser {
            return .currentUser(currentUser)
        } else if let currentSignedUpUser = model as? CurrentSignedUpUser {
            return .currentSignedUpUser(currentSignedUpUser)
        } else {
            return nil
        }
    }
    
    func forEach(_ visit: (Model) -> Void) { visit(model) }
}

extension EitherCurrentUser: AutoEquatable {}
