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
    let synopsis: String?
    let posterURL: URL
    let runningTime: Int?
    fileprivate(set) var status: Variable<FilmStatus?>
    
    required init(json: JsonType) throws {
        id = try json.parse(key: "id")
        title = try json.parse(key: "title")
        
        runningTime = json["running_time"] as? Int
        synopsis = json["synopsis"] as? String
        
        let userRating = json["user_rating"] as? [AnyHashable : Any]
        if let userRatingScore = userRating?["rating"] as? Double, let rating = Rating(rawValue: userRatingScore) {
            status = Variable(.rated(rating))
        } else if let wantToWatch = json["want_to_watch"] as? Bool, wantToWatch {
            status = Variable(.wantToWatch)
        } else {
            status = Variable(nil)
        }
        
        let posterUrlString: String = try json.parseDict(key: "posters").parseDict(key: "thumbnail").parse(key: "url")
        guard let posterURL = URL(string: posterUrlString) else { throw ParserError.couldNotParse }
        self.posterURL = posterURL
    }
    
    func addToWatchList() -> Observable<AddFilmToWatchList.SuccessData> {
        return Observable.create { obserable in
            guard self.status.value != .wantToWatch else {
                obserable.on(.next(NoSuccessData()))
                obserable.on(.completed)
                return Disposables.create()
            }
            
            let observable = AddFilmToWatchList(film: self).call()
            return observable.subscribe { [weak self] event in
                switch event {
                case .next(let success):
                    self?.status.value = .wantToWatch
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
    case rated(Rating)
}

extension FilmStatus: Equatable {}
func ==(lhs: FilmStatus, rhs: FilmStatus) -> Bool {
    switch (lhs, rhs) {
    case (.wantToWatch, .wantToWatch): return true
    case let (.rated(lhsRating), .rated(rhsRating)): return lhsRating == rhsRating
    default: return false
    }
}

enum Rating: Double, RawRepresentable {
    case one = 1
    case onePointFive = 1.5
    case two = 2
    case twoPointFive = 2.5
    case three = 3
    case threePointFive = 3.5
    case four = 4
    case fourPointFive = 4.5
    case five = 5
    
    public typealias RawValue = Double
}

extension Film: JSONDecodeable {
    typealias JsonType = [AnyHashable : Any]
}
