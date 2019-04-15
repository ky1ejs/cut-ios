//
//  EitherCurrentUserRepository.swift
//  Cut
//
//  Created by Kyle McAlpine on 25/03/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import Foundation
import RxSwift
import RocketData
import ConsistencyManager

class EitherCurrentUserRepository {
    private let state = Variable<RepositoryState<EitherCurrentUser>>(.notFetched)
    var user: EitherCurrentUser? { return state.value.latest }
    private var disposeBag = DisposeBag()
    
    init() {
        DataModelManager.sharedInstance.consistencyManager.addModelUpdatesListener(self)
    }
    
    func refresh() -> Observable<EitherCurrentUser> {
        let observable = GetCurrentUser().call().share()
        _ = observable.subscribe({ event in
            guard let newState = RepositoryState(event: event) else { return }
            guard newState != self.state.value else { return }
            self.state.value = newState
            if case .latest(let user) = newState {
                DataModelManager.sharedInstance.consistencyManager.updateModel(user)
            }
        })
        return observable
    }
    
    func logOut() -> Observable<CurrentUser> {
        let observable = LogOut().call().share()
        
        _ = observable.map { user -> RepositoryState<EitherCurrentUser> in
            return RepositoryState<EitherCurrentUser>.latest(.currentUser(user))
        }.catchError { (error) -> Observable<RepositoryState<EitherCurrentUser>> in
            return Observable.just(.error(error))
        }.subscribe(onNext: { newState in
            guard newState != self.state.value else { return }
            self.state.value = newState
            if case .latest(let user) = newState {
                DataModelManager.sharedInstance.consistencyManager.updateModel(user)
            }
        })
        
        return observable
    }
}

extension EitherCurrentUserRepository: ConsistencyManagerUpdatesListener {
    func consistencyManager(_ consistencyManager: ConsistencyManager, updatedModel model: ConsistencyManagerModel, changes: [String : ModelChange], context: Any?) {
        let parseModel: (ConsistencyManagerModel) -> EitherCurrentUser? = { model in
            if let currentUser = model as? CurrentUser {
                return .currentUser(currentUser)
            } else if let loggedInUser = model as? CurrentSignedUpUser {
                return .currentSignedUpUser(loggedInUser)
            } else if let eitherUser = model as? EitherCurrentUser {
                return eitherUser
            } else {
                return nil
            }
        }
        
        guard let updatedModel = parseModel(model)              else { return }
        guard updatedModel != state.value.latest                else { return }
        state.value = .latest(updatedModel)
    }
}

extension EitherCurrentUserRepository: ObservableType {
    typealias E = RepositoryState<EitherCurrentUser>
    
    func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, EitherCurrentUserRepository.E == O.E {
        let disposable = state.asObservable().subscribe(observer)
        _ = refresh().subscribe()
        return disposable
    }
}
