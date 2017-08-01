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
        static let host = URL(string: "http://localhost:3000")!
    #else
        static let host = URL(string: "https://cut.watch")!
    #endif
    
    static let version = host.appendingPathComponent("v1")
    
    static let watchList    = version.appendingPathComponent("watch-list")
    static let films        = version.appendingPathComponent("films")
    static let feed         = version.appendingPathComponent("feed")
    static let ratings      = version.appendingPathComponent("ratings")
    static let search       = version.appendingPathComponent("search")
    static let devices      = version.appendingPathComponent("devices")
    static let deviceToken  = devices.appendingPathComponent("token")
    
    static let users        = version.appendingPathComponent("users")
    static let login        = users.appendingPathComponent("login")
}
