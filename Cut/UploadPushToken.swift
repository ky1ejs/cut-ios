//
//  UploadPushToken.swift
//  Cut
//
//  Created by Kyle McAlpine on 03/05/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct UploadPushToken {
    let token: String
}

extension UploadPushToken: Endpoint {
    typealias SuccessData = NoSuccessData
    var url: URL { return CutEndpoints.deviceToken }
    var method: HTTPMethod { return .post }
    var body: [String : Any] { return ["push_token" : token] }
}
