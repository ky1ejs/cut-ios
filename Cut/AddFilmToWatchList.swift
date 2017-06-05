//
//  AddFilmToWatchList.swift
//  Cut
//
//  Created by Kyle McAlpine on 08/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

struct AddFilmToWatchList {
    let film: Film
    let delete: Bool
}

extension AddFilmToWatchList: Endpoint {
    typealias SuccessData = NoSuccessData
    var url: URL                { return CutEndpoints.watchList                                         }
    var body: [String : Any]    { return ["film_id" : film.id]                                          }
    var method: HTTPMethod      { return delete ? .delete : .post                                       }
    var onSuccess: () -> ()     { return { self.film.status.value = self.delete ? nil : .wantToWatch }  }
}
