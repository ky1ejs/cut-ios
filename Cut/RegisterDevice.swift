//
//  RegisterDevice.swift
//  Cut
//
//  Created by Kyle McAlpine on 07/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct RegisterDevice {
    let deviceID = UUID().uuidString
}

extension RegisterDevice: Endpoint {
    typealias SuccessData = NoSuccessData
    var url: URL { return URL(string: "http://localhost:3000/v1/devices")! }
    var body: [String : String] { return ["device_id" : deviceID] }
}
