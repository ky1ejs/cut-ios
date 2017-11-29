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
    let id:                             String
    let title:                          String
    let synopsis:                       String?
    let thumbnailImageURL:              URL?
    let profileImageURL:                URL?
    let heroImageURL:                   URL?
    let runningTime:                    Int?
    let ratings:                        [PercentageRating]
    let theaterReleaseDate:             Date?
    let relativeTheaterReleaseDate:     String?
    let trailers:                       [Trailer]?
    
    fileprivate(set) var status: Variable<FilmStatus?>
    
    required init(json: JsonType) throws {
        id = try json.parse(key: "id")
        title = try json.parse(key: "title")
        
        runningTime = json["running_time"] as? Int
        synopsis = json["synopsis"] as? String
        
        let userRating = json["user_rating"] as? [AnyHashable : Any]
        if let userRatingScore = userRating?["rating"] as? Double, let rating = StarRating(rawValue: userRatingScore) {
            status = Variable(.rated(rating))
        } else if let wantToWatch = json["want_to_watch"] as? Bool, wantToWatch {
            status = Variable(.wantToWatch)
        } else {
            status = Variable(nil)
        }
        
        if let releaseDateString = json["theater_release_date"] as? String {
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            theaterReleaseDate = df.date(from: releaseDateString)
        } else {
            theaterReleaseDate = nil
        }
        relativeTheaterReleaseDate = json["relative_theater_release_date"] as? String
        
        ratings = try (json["ratings"] as? [[AnyHashable : Any]])?.flatMap(PercentageRating.init) ?? [PercentageRating]()
        
        let posters = json.tryParseDict(key: "posters")
        thumbnailImageURL = posters?.tryParseDict(key: "thumbnail")?.parseDecodable(key: "url")
        profileImageURL = posters?.tryParseDict(key: "profile")?.parseDecodable(key: "url")
        heroImageURL = posters?.tryParseDict(key: "hero")?.parseDecodable(key: "url")
        
        let trailerJSON: [String : Trailer.JsonType] = try json.parse(key: "trailers")
        trailers = try? ArrayResponse<Trailer>(json: Array(trailerJSON.values)).models
        print(trailers)
    }
    
    func addToWatchList() -> Observable<AddFilmToWatchList.SuccessData> {
        return Observable.create { obserable in
            guard self.status.value != .wantToWatch else {
                obserable.on(.next(NoSuccessData()))
                obserable.on(.completed)
                return Disposables.create()
            }
            
            let observable = AddFilmToWatchList(film: self, action: .add).call()
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

extension Film: JSONDecodeable {
    typealias JsonType = [AnyHashable : Any]
}


