//
//  Film.swift
//  Cut
//
//  Created by Kyle McAlpine on 03/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation
import RocketData

struct Film: JSONDecodeable {
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
    let status:                         FilmStatus?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case synopsis
        case runningTime
        case userRating
        case rating
        case wantToWatch
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(key: .id)
        title = try container.decode(key: .title)
        
        runningTime = try? container.decode(key: .runningTime)
        synopsis = try? container.decode(key: .synopsis)
        
        let userRating: [String : Any]? = try? container.decode([String : Any], forKey: CodingKeys.userRating)
        if let userRatingScore = userRating?["rating"] as? Double, let rating = StarRating(rawValue: userRatingScore) {
            status = .rated(rating)
        } else if let wantToWatch = try? container.decode(key: .wantToWatch), wantToWatch {
            status = .wantToWatch
        } else {
            status = nil
        }
    }
}

extension Film: CustomJSONDecodable {
    typealias JsonType = [AnyHashable : Any]
    
    init(json: JsonType) throws {
        
        
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
        trailers = try? Array<Trailer>(json: Array(trailerJSON.values))
    }
}

extension Film: Model {
    var modelIdentifier: String? { return id }
    func map(_ transform: (Model) -> Model?) -> Film? { return self }
    func forEach(_ visit: (Model) -> Void) {}
}

extension Film: AutoEquatable {}

//func addToWatchList() -> Observable<AddFilmToWatchList.SuccessData> {
//    return Observable.create { obserable in
//        guard self.status.value != .wantToWatch else {
//            obserable.on(.next(NoSuccessData()))
//            obserable.on(.completed)
//            return Disposables.create()
//        }
//
//        let observable = AddFilmToWatchList(film: self, action: .add).call()
//        return observable.subscribe { [weak self] event in
//            switch event {
//            case .next(let success):
//                self?.status.value = .wantToWatch
//                obserable.on(.next(success))
//            case .error(let error):
//                obserable.on(.error(error))
//            case .completed:
//                obserable.on(.completed)
//            }
//        }
//    }
//
//}
//
//
