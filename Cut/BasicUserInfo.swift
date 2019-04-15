//
//  BasicUserInfo.swift
//  Cut
//
//  Created by Kyle McAlpine on 30/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import Foundation

struct BasicUserInfo: JSONDecodeable {
    let id:                String
    let watchListCount:    Int
    let ratedCount:        Int
}

extension BasicUserInfo: AutoEquatable {}
