//
//  StringExtensions.swift
//  Cut
//
//  Created by Kyle McAlpine on 02/05/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

extension String {
    init(hexData: Data) {
        var str = String()
        let p = (hexData as NSData).bytes.bindMemory(to: UInt8.self, capacity: hexData.count)
        let len = hexData.count
        
        for i in 0 ..< len {
            str += String(format: "%02.2x", p[i])
        }
        self = str
    }
}
