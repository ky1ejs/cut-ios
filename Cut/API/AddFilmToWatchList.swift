//
//  AddFilmToWatchList.swift
//  Cut
//
//  Created by Kyle McAlpine on 08/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

enum WatchListAction {
    case add
    case remove
    
    fileprivate var method: HTTPMethod {
        switch self {
        case .add:      return .post
        case .remove:   return .delete
        }
    }
}

struct AddFilmToWatchList {
    let film: Film
    let action: WatchListAction
}

extension AddFilmToWatchList: Endpoint {
    typealias SuccessData = NoSuccessData
    var url: URL                { return CutEndpoints.watchList }
    var body: [String : Any]    { return ["film_id" : film.id] }
    var method: HTTPMethod      { return action.method }
    var onSuccess: (SuccessData) -> () { return { _ in self.film.status.value = self.action == .add ? .wantToWatch : nil }  }
}
