//
//  SignedUpUserInfo.swift
//  Cut
//
//  Created by Kyle McAlpine on 30/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import Foundation

struct SignedUpUserInfo {
    var id:                String   { return basicInfo.id }
    let username:          String
    let followerCount:     Int
    let followingCount:    Int
    var watchListCount:    Int      { return basicInfo.watchListCount }
    var ratedCount:        Int      { return basicInfo.ratedCount }
    let profileImageURL:   URL?
    
    private let basicInfo: BasicUserInfo
}

extension SignedUpUserInfo: JSONDecodeable {
    typealias JsonType = [AnyHashable : Any]
    
    init(json: JsonType) throws {
        username = try json.parse(key: "username")
        followerCount = try json.parse(key: "follower_count")
        followingCount = try json.parse(key: "following_count")
        profileImageURL = {
            guard let urlString = json["profile_image"] as? String else { return nil }
            return URL(string: urlString)
        }()
        
        basicInfo = try BasicUserInfo(json: json)
    }
}

extension SignedUpUserInfo: AutoEquatable {}
