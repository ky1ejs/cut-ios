//
//  ArrayResponse.swift
//  Cut
//
//  Created by Kyle McAlpine on 11/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct ArrayResponse<Model: JSONDecodeable>: JSONDecodeable {
    typealias JsonType = [Model.JsonType]
    let models: [Model]
    
    init(json: JsonType) throws {
        models = try json.map(Model.init)
    }
}

extension ArrayResponse: Sequence {
    func makeIterator() -> Array<Model>.Iterator {
        return models.makeIterator()
    }
}
