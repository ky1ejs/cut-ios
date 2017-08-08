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
        
        if let posters = json.tryParseDict(key: "posters") {
            let thumbnailUrlString: String = try posters.parseDict(key: "thumbnail").parse(key: "url")
            let profileUrlString:   String = try posters.parseDict(key: "profile").parse(key: "url")
            let heroUrlString:      String = try posters.parseDict(key: "hero").parse(key: "url")
        
            guard let thumbnailUrl  = URL(string: thumbnailUrlString)   else { throw ParserError.couldNotParse }
            guard let profileUrl    = URL(string: profileUrlString)     else { throw ParserError.couldNotParse }
            guard let heroImageURL  = URL(string: heroUrlString)        else { throw ParserError.couldNotParse }
            
            self.thumbnailImageURL = thumbnailUrl
            self.profileImageURL = profileUrl
            self.heroImageURL = heroImageURL
        } else {
            thumbnailImageURL = nil
            profileImageURL = nil
            heroImageURL = nil
        }
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


