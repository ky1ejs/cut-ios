//
//  Repository.swift
//  Cut
//
//  Created by Kyle McAlpine on 17/03/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import Foundation
import RxSwift
import RocketData
import ConsistencyManager

class Repository<M: ConsistencyManagerModel> {
    private(set) var model: M
    
    private var disposeBag = DisposeBag()
    
    init(model: M) {
        self.model = model
    }
    
    func call<E>(endpoint: E) -> Observable<M> where E: Endpoint, M == E.SuccessData {
        let observable = endpoint.call().share()
        _ = observable.subscribe(onNext: { model in
            self.model = model
            DataModelManager.sharedInstance.consistencyManager.updateModel(model)
        }).disposed(by: disposeBag)
        return observable
    }
}

extension Repository: ConsistencyManagerListener {
    func currentModel() -> ConsistencyManagerModel? {
        return model
    }
    
    func modelUpdated(_ model: ConsistencyManagerModel?, updates: ModelUpdates, context: Any?) {
        guard let model = model as? M else { return }
        self.model = model
    }
}

class UserRepository {
    private let _user: Variable<User>
    var user: User { return _user.value }
    
    private var disposeBag = DisposeBag()
    
    init(user: User) {
        self._user = Variable<User>(user)
        DataModelManager.sharedInstance.consistencyManager.addListener(self, to: user)
    }
    
    func toggleFollowing() -> Observable<User> {
        let observable = FollowUnfollowUser(username: user.info.username, follow: !user.following).call().share()
        _ = observable.subscribe(onNext: { user in
            self._user.value = user
            DataModelManager.sharedInstance.consistencyManager.updateModel(user)
        }).disposed(by: disposeBag)
        return observable
    }
}

extension UserRepository: ObservableType {
    typealias E = User
    
    func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, UserRepository.E == O.E {
        return _user.asObservable().subscribe(observer)
    }
}

extension UserRepository: ConsistencyManagerListener {
    func currentModel() -> ConsistencyManagerModel? {
        return user
    }
    
    func modelUpdated(_ model: ConsistencyManagerModel?, updates: ModelUpdates, context: Any?) {
        guard let user = model as? User else { return }
        _user.value = user
    }
}

enum RepositoryState<Data: Equatable> {
    case notFetched
    case latest(Data)
    case error(Error)
    
    var latest: Data? {
        guard case .latest(let data) = self else { return nil }
        return data
    }
}

extension RepositoryState {
    init?(event: Event<Data>) {
        switch event {
        case .next(let user):   self = .latest(user)
        case .error(let error): self = .error(error)
        case.completed:         return nil
        }
    }
}

extension RepositoryState: Equatable {
    static func ==(lhs: RepositoryState<Data>, rhs: RepositoryState<Data>) -> Bool {
        switch (lhs, rhs) {
        case (.notFetched, .notFetched):
            return true
        case let (.latest(lhsData), .latest(rhsData)):
            return lhsData == rhsData
        case let (.error(lhsError as NSError), .latest(rhsError as NSError)):
            return lhsError.code == rhsError.code && lhsError.domain == rhsError.domain
        default:
            return false
        }
    }
}
