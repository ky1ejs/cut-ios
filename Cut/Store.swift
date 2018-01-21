//
//  Store.swift
//  Cut
//
//  Created by Kyle McAlpine on 09/11/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation
import RxSwift

// 1. VC subsribes to data
// 2. Store gives current state immediately - VC should be able to set loading or show no data state
// 3. Store requests latest data from server async
// 4. Store parses data and provides latest state to all observers
// 5. On error, the store notifies observers - how does the key VC know when to show an error for a given user action (e.g. system error, no internet)

struct Store {
    private static var userState = Variable(StoreState<CurrentUser>.notFetched)
    
    static let user = Observable<StoreState<CurrentUser>>.create { (observer) -> Disposable in
        let variableSub = userState.asObservable().subscribe(observer)
        
        if case .notFetched = userState.value { updateUser() }
        
        return Disposables.create([variableSub])
    }
    
    static func updateUser() {
        // force a user update
        _ = GetUser().call().subscribe { event in
            switch event {
            case .next(let user):   userState.value = .latest(user)
            case .error(let error): userState.value = .error(error)
            case .completed:        break
            }
        }
    }
    
    static func update(_ user: CurrentUser) {
        userState.value = .latest(user)
    }
}

enum StoreState<Data> {
    case latest(Data)
    case notFetched
    case error(Error)
}
