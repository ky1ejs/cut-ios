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
    let profileImageURL: URL?
    var isFullUser: Bool { return email.value != nil && username.value != nil }
    
    required init(json: JsonType) throws {
        email = Variable(json["email"] as? String)
        username = Variable(json["username"] as? String)
        
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
            
            let signUp = SignUp(email: email, username: 	username, password: password).call().subscribe { [weak self] event in
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
            
            return Disposables.create {
                signUp.dispose()
            }
        }
    }
}
