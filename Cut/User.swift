//
//  User.swift
//  Cut
//
//  Created by Kyle McAlpine on 21/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import Foundation
import RxSwift

struct User {
    let username: String
    let followerCount: Int
    let followingCount: Int
    let watchListCount: Int
    let ratedCount: Int
    let profileImageURL: URL?
    
    let following: Variable<Bool>
}

extension User: JSONDecodeable {
    typealias JsonType = [AnyHashable : Any]
    
    init(json: JsonType) throws {
        username = try json.parse(key: "username")
        followerCount = try json.parse(key: "follower_count")
        followingCount = try json.parse(key: "following_count")
        watchListCount = try json.parse(key: "watch_list_count")
        ratedCount = try json.parse(key: "rated_count")
        profileImageURL = {
            guard let urlString = json["profile_image"] as? String else { return nil }
            return URL(string: urlString)
        }()
        following = Variable(try json.parse(key: "following"))
    }
    
    func toggleFollowing() -> Observable<FollowUnfollowUser.SuccessData> {
        return Observable.create { observer in
            let followUnfollow = FollowUnfollowUser(username: self.username, follow: !self.following.value).call().subscribe { event in
                switch event {
                case .next(let empty):
                    self.following.value = !self.following.value
                    observer.onNext(empty)
                case .error(let error):
                    observer.onError(error)
                case .completed:
                    observer.onCompleted()
                }
            }
            
            return Disposables.create { followUnfollow.dispose() }
        }
    }}
