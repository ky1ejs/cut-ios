//
//  ArrayResponse.swift
//  Cut
//
//  Created by Kyle McAlpine on 11/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

extension Array where Element: JSONDecodeable {
    init(json: JsonType) throws {
        guard let json = json as? [Element.JsonType] else { throw ParserError.couldNotParse }
        self.init(try json.map(Element.init))
    }
}

extension Array: JSONDecodeable {
    typealias JsonType = Any
    
    init(json: JsonType) throws {
        throw ParserError.couldNotParse
    }
}
