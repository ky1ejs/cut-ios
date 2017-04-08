//
//  RottenTomatoesListMovies.swift
//  Cut
//
//  Created by Kyle McAlpine on 22/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

enum MovieFilter: String {
    case popular = "popular"
    case topBoxOffice = "top-box-office"
    case upcoming = "theater-upcoming"
    case newDvdReleases = "new-release-dvds"
}

extension MovieFilter: CustomStringConvertible {
    var description: String {
        switch self {
        case .popular:          return "In Theaters"
        case .topBoxOffice:     return "Top Box Office"
        case .upcoming:         return "Upcoming"
        case .newDvdReleases:   return "DVDs"
        }
    }
}

struct ListMovies {
    let deviceID = "ios_\(UIDevice.current.identifierForVendor!.uuidString)"
}

extension ListMovies: Endpoint {
    typealias SuccessData = ArrayResponse<Movie>
    var url: URL { return URL(string: "http://localhost:3000/v1/films")! }
    var headers: [String : String] { return ["device_id" : deviceID] }
}

struct ArrayResponse<Model: JSONDecodeable>: JSONDecodeable {
    typealias JsonType = [Model.JsonType]
    let models: [Model]
    
    init(json: JsonType) throws {
        models = try json.map(Model.init)
    }
}

extension ArrayResponse: Sequence {
    func makeIterator() -> Array<Model>.Iterator {
        return models.makeIterator()
    }
}
