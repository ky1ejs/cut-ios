//
//  CutEndpoints.swift
//  Cut
//
//  Created by Kyle McAlpine on 02/05/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct CutEndpoints {
    #if LOCAL
        static let host: URL = {
            let local = Bundle.main.infoDictionary!["LocalIP"] as! String
            return URL(string: "http://\(local):3000")!
        }()
    #elseif STAGING
        static let host = URL(string: "https://cut-api-staging.herokuapp.com")!
    #else
        static let host = URL(string: "https://api.cut.watch")!
    #endif
    
    static let base = host.appendingPathComponent("v1")
    
    static let watchList        = base.appendingPathComponent("watch-list")
    static let films            = base.appendingPathComponent("films")
    static let feed             = base.appendingPathComponent("feed")
    static let ratings          = base.appendingPathComponent("ratings")
    static let search           = base.appendingPathComponent("search")
    static let users            = base.appendingPathComponent("users")
    static let login            = base.appendingPathComponent("login")
    static let logout           = base.appendingPathComponent("logout")
    static let signUp           = base.appendingPathComponent("sign-up")
    static let qrCode           = base.appendingPathComponent("qr")
    
    static let devices          = base.appendingPathComponent("devices")
    static let devicePushToken  = devices.appendingPathComponent("push-token")
}
