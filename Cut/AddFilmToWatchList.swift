//
//  AddFilmToWatchList.swift
//  Cut
//
//  Created by Kyle McAlpine on 08/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

struct AddFilmToWatchList {
    let film: Movie
    let deviceID = "ios_\(UIDevice.current.identifierForVendor!.uuidString)"
}

extension AddFilmToWatchList: Endpoint {
    typealias SuccessData = NoSuccessData
    var url: URL { return URL(string: "http://localhost:3000/v1/watch-list")! }
    var headers: [String : String] { return ["device_id" : deviceID] }
    var body: [String : String] { return ["film_id" : film.id] }
    static var method: HTTPMethod { return .post }
}
