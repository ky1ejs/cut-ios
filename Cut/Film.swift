//
//  Film.swift
//  Cut
//
//  Created by Kyle McAlpine on 03/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation
import RxSwift

class Film {
    let id: String
    let title: String
    let synopsis: String
    let posterURL: URL
    let runningTime: Int?
    fileprivate(set) var status: FilmStatus?
    let userRatingScore: Variable<Double?>
    
    required init(json: JsonType) throws {
        id = try json.parse(key: "id")
        title = try json.parse(key: "title")
        synopsis = try json.parse(key: "synopsis")
        
        runningTime = json["running_time"] as? Int
        
        let userRating = json["user_rating"] as? [AnyHashable : Any]
        userRatingScore = Variable(userRating?["rating"] as? Double)
        
        let wantToWatch = json["want_to_watch"] as? Bool ?? false
        status = wantToWatch ? .wantToWatch : nil
        
        let posterUrlString: String = try json.parseDict(key: "posters").parseDict(key: "thumbnail").parse(key: "url")
        guard let posterURL = URL(string: posterUrlString) else { throw ParserError.couldNotParse }
        self.posterURL = posterURL
    }
    
    func addToWatchList() -> Observable<AddFilmToWatchList.SuccessData> {
        return Observable.create { obserable in
            guard self.status != .wantToWatch else {
                obserable.on(.next(NoSuccessData()))
                obserable.on(.completed)
                return Disposables.create()
            }
            
            let observable = AddFilmToWatchList(film: self).call()
            return observable.subscribe { [weak self] event in
                switch event {
                case .next(let success):
                    self?.status = .wantToWatch
                    obserable.on(.next(success))
                case .error(let error):
                    obserable.on(.error(error))
                case .completed:
                    obserable.on(.completed)
                }
            }
        }
        
    }
}

enum FilmStatus {
    case wantToWatch
    case watched(Rating?)
}

extension FilmStatus: Equatable {}
func ==(lhs: FilmStatus, rhs: FilmStatus) -> Bool {
    switch (lhs, rhs) {
    case (.wantToWatch, .wantToWatch): return true
    case let (.watched(lhsRating), .watched(rhsRating)): return lhsRating == rhsRating
    default: return false
    }
}

enum Rating: Int {
    case one
    case two
    case three
    case four
    case five
}

extension Film: JSONDecodeable {
    typealias JsonType = [AnyHashable : Any]
}
