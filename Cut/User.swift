//
//  User.swift
//  Cut
//
//  Created by Kyle McAlpine on 10/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation
import RxSwift

private typealias Credentials = (email: String, username: String)

class User: JSONDecodeable {
    typealias JsonType = [AnyHashable : Any]
    private var details: Credentials?
    
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
                    safeSelf.details?.email = user.email!
                    safeSelf.details?.username = user.username!
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
