//
//  JSON.swift
//  Cut
//
//  Created by Kyle McAlpine on 23/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

extension Dictionary {
    func parse<T>(key: Key) throws -> T {
        guard let value = self[key] as? T else { throw ParserError.couldNotParse }
        return value
    }
}

extension Dictionary where Key == AnyHashable, Value == Any {
    func parseDict(key: Key) throws -> [Key : Value] {
        return try parse(key: key)
    }
}
