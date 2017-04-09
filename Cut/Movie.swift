//
//  Movie.swift
//  Cut
//
//  Created by Kyle McAlpine on 03/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation
import RxSwift

class Movie {
    let id: String
    let title: String
    let synopsis: String
    let posterURL: URL
    let runningTime: Int?
    fileprivate(set) var status: MovieStatus?
    
    required init(json: JsonType) throws {
        id = try json.parse(key: "id")
        title = try json.parse(key: "title")
        runningTime = try json.parse(key: "running_time")
        synopsis = try json.parse(key: "synopsis")
        
        let wantToWatch: Bool = try json.parse(key: "want_to_watch")
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

enum MovieStatus {
    case wantToWatch
    case watched(Rating?)
}

extension MovieStatus: Equatable {}
func ==(lhs: MovieStatus, rhs: MovieStatus) -> Bool {
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

extension Movie: JSONDecodeable {
    typealias JsonType = [AnyHashable : AnyObject]
}
