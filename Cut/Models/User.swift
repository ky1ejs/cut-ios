//
//  User.swift
//  Cut
//
//  Created by Kyle McAlpine on 10/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation
import RxSwift

class User: JSONDecodeable {
    typealias JsonType = [AnyHashable : Any]
    
    var email: Variable<String?>
    var username: Variable<String?>
    var following: Variable<Bool>
    let profileImageURL: URL?
    var isFullUser: Bool { return email.value != nil && username.value != nil }
    
    required init(json: JsonType) throws {
        email = Variable(json["email"] as? String)
        username = Variable(json["username"] as? String)
        
        let following = (json["following"] as? Bool) ?? false
        self.following = Variable(following)
        
        profileImageURL = {
            if let imageUrl = json["profile_image"] as? String {
                return URL(string: imageUrl)
            }
            return nil
        }()
    }
    
    func signUp(email: String, username: String, password: String) -> Observable<User> {
        return Observable.create { [weak self] observer in
            guard let safeSelf = self, !safeSelf.isFullUser else {
                observer.on(.error(RxError.unknown))
                observer.on(.completed)
                return Disposables.create()
            }
            
            let signUp = SignUp(email: email, username: username, password: password).call().subscribe { [weak self] event in
                guard let safeSelf = self else {
                    observer.on(.error(RxError.unknown))
                    observer.on(.completed)
                    return
                }
                switch event {
                case .next(let user):
                    safeSelf.email.value = user.email.value
                    safeSelf.username.value = user.username.value
                    observer.onNext(safeSelf)
                    observer.onCompleted()
                case .error(let error):
                    observer.onError(error)
                case .completed:
                    observer.onCompleted()
                }
            }
            
            return Disposables.create { signUp.dispose() }
        }
    }
    
    func login(emailOrUsername: String, password: String) -> Observable<User> {
        return Observable.create { [weak self] observer in
            guard let safeSelf = self, !safeSelf.isFullUser else {
                observer.on(.error(RxError.unknown))
                observer.on(.completed)
                return Disposables.create()
            }
            
            let login = LogIn(emailOrUsername: emailOrUsername, password: password).call().subscribe { [weak self] event in
                guard let safeSelf = self else {
                    observer.on(.error(RxError.unknown))
                    observer.on(.completed)
                    return
                }
                switch event {
                case .next(let user):
                    safeSelf.email.value = user.email.value
                    safeSelf.username.value = user.username.value
                    observer.onNext(safeSelf)
                    observer.onCompleted()
                case .error(let error):
                    observer.onError(error)
                case .completed:
                    observer.onCompleted()
                }
            }
            
            return Disposables.create { login.dispose() }
        }
    }
    
    func logOut() -> Observable<User> {
        return Observable.create { [weak self] observer in
            guard let safeSelf = self, safeSelf.isFullUser else {
                observer.on(.error(RxError.unknown))
                observer.on(.completed)
                return Disposables.create()
            }
            
            let logout = LogOut().call().subscribe { [weak self] event in
                guard let safeSelf = self else {
                    observer.on(.error(RxError.unknown))
                    observer.on(.completed)
                    return
                }
                switch event {
                case .next(let user):
                    safeSelf.email.value = user.email.value
                    safeSelf.username.value = user.username.value
                    observer.onNext(safeSelf)
                    observer.onCompleted()
                case .error(let error):
                    observer.onError(error)
                case .completed:
                    observer.onCompleted()
                }
            }
            
            return Disposables.create { logout.dispose() }
        }
    }
    
    func toggleFollowing() -> Observable<FollowUnfollowUser.SuccessData> {
        guard let username = username.value else {
            return Observable.create { observer in
                observer.onError(RxError.unknown)
                observer.onCompleted()
                
                return Disposables.create()
            }
        }
        
        return Observable.create { observer in
            let followUnfollow = FollowUnfollowUser(username: username, follow: !self.following.value).call().subscribe { event in
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
    }
}
