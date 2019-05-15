//
//  CurrentUser.swift
//  Cut
//
//  Created by Kyle McAlpine on 10/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CurrentUser: JSONDecodeable {
    typealias JsonType = [AnyHashable : Any]
    
    var email: BehaviorRelay<String?>
    var username: BehaviorRelay<String?>
    var following: BehaviorRelay<Bool>
    var followerCount: BehaviorRelay<Int>
    let profileImageURL: URL?
    var isFullUser: Bool { return email.value != nil && username.value != nil }
    
    required init(json: JsonType) throws {
        email = BehaviorRelay(value: json["email"] as? String)
        username = BehaviorRelay(value: json["username"] as? String)
        followerCount = BehaviorRelay(value: json["follower_count"] as? Int ?? 0)
        
        let following = (json["following"] as? Bool) ?? false
        self.following = BehaviorRelay(value: following)
        
        profileImageURL = {
            if let imageUrl = json["profile_image"] as? String {
                return URL(string: imageUrl)
            }
            return nil
        }()
    }
    
    func signUp(email: String, username: String, password: String) -> Observable<CurrentUser> {
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
                    safeSelf.email.accept(user.email.value)
                    safeSelf.username.accept(user.username.value)
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
    
    func login(emailOrUsername: String, password: String) -> Observable<CurrentUser> {
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
                    safeSelf.email.accept(user.email.value)
                    safeSelf.username.accept(user.username.value)
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
    
    func logOut() -> Observable<CurrentUser> {
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
                    safeSelf.email.accept(user.email.value)
                    safeSelf.username.accept(user.username.value)
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
    
    var observable: Observable<CurrentUser> {
        return Observable.create { observer -> Disposable in
            return Disposables.create([
                self.email.asObservable().bind() { _ in observer.onNext(self) },
                self.username.asObservable().bind() { _ in observer.onNext(self) },
                self.following.asObservable().bind() { _ in observer.onNext(self) }
//            let profileImageURL: URL?
//            var isFullUser: Bool { return email.value != nil && username.value != nil }
            ])
        }
    }
}
