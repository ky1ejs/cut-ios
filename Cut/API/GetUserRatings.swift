//
//  GetUserRatingswift
//  Cut
//
//  Created by Kyle McAlpine on 25/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import Foundation

struct GetUserRatings {
    let username: String
}

extension GetUserRatings: Endpoint {
    typealias SuccessData = ArrayResponse<Watch>
    var url: URL { return CutEndpoints.users.appendingPathComponent("\(username)/ratings") }
}

