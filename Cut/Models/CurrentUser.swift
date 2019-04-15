//
//  CurrentUser.swift
//  Cut
//
//  Created by Kyle McAlpine on 10/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation
import RocketData

struct CurrentUser: JSONDecodeable {
    let info: BasicUserInfo
}

extension CurrentUser: Model {
    var modelIdentifier: String? { return info.id }
    func map(_ transform: (Model) -> Model?) -> CurrentUser? { return self }
    func forEach(_ visit: (Model) -> Void) {}
}

extension CurrentUser: AutoEquatable {}

//func logOut() -> Observable<CurrentUser> {
//    return Observable.create { [weak self] observer in
//        guard let safeSelf = self, safeSelf.isFullUser else {
//            observer.on(.error(RxError.unknown))
//            observer.on(.completed)
//            return Disposables.create()
//        }
//
//        let logout = LogOut().call().subscribe { [weak self] event in
//            guard let safeSelf = self else {
//                observer.on(.error(RxError.unknown))
//                observer.on(.completed)
//                return
//            }
//            switch event {
//            case .next(let user):
//                safeSelf.email.value = user.email.value
//                safeSelf.username.value = user.username.value
//                observer.onNext(safeSelf)
//                observer.onCompleted()
//            case .error(let error):
//                observer.onError(error)
//            case .completed:
//                observer.onCompleted()
//            }
//        }
//
//        return Disposables.create { logout.dispose() }
//    }
//}

//func signUp(email: String, username: String, password: String) -> Observable<CurrentUser> {
//    return Observable.create { [weak self] observer in
//        guard let safeSelf = self, !safeSelf.isFullUser else {
//            observer.on(.error(RxError.unknown))
//            observer.on(.completed)
//            return Disposables.create()
//        }
//
//        let signUp = SignUp(email: email, username: username, password: password).call().subscribe { [weak self] event in
//            guard let safeSelf = self else {
//                observer.on(.error(RxError.unknown))
//                observer.on(.completed)
//                return
//            }
//            switch event {
//            case .next(let user):
//                safeSelf.email.value = user.email.value
//                safeSelf.username.value = user.username.value
//                observer.onNext(safeSelf)
//                observer.onCompleted()
//            case .error(let error):
//                observer.onError(error)
//            case .completed:
//                observer.onCompleted()
//            }
//        }
//
//        return Disposables.create { signUp.dispose() }
//    }
//}
//
//func login(emailOrUsername: String, password: String) -> Observable<CurrentUser> {
//    return Observable.create { [weak self] observer in
//        guard let safeSelf = self, !safeSelf.isFullUser else {
//            observer.on(.error(RxError.unknown))
//            observer.on(.completed)
//            return Disposables.create()
//        }
//
//        let login = LogIn(emailOrUsername: emailOrUsername, password: password).call().subscribe { [weak self] event in
//            guard let safeSelf = self else {
//                observer.on(.error(RxError.unknown))
//                observer.on(.completed)
//                return
//            }
//            switch event {
//            case .next(let user):
//                safeSelf.email.value = user.email.value
//                safeSelf.username.value = user.username.value
//                observer.onNext(safeSelf)
//                observer.onCompleted()
//            case .error(let error):
//                observer.onError(error)
//            case .completed:
//                observer.onCompleted()
//            }
//        }
//
//        return Disposables.create { login.dispose() }
//    }
//}

