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
    
    func parseDecodable<T: JSONDecodeable>(key: Key) throws -> T {
        guard let json = self[key] as? T.JsonType else { throw ParserError.couldNotParse }
        return try T(json: json)
    }
    
    func tryParse<T>(key: Key) -> T? {
        return self[key] as? T
    }
    
    func parseDecodable<T: JSONDecodeable>(key: Key) -> T? {
        return try? parseDecodable(key: key)
    }
}

extension Dictionary where Key == AnyHashable, Value == Any {
    func parseDict(key: Key) throws -> [Key : Value] {
        return try parse(key: key)
    }
    
    func tryParseDict(key: Key) -> [Key : Value]? {
        return tryParse(key: key)
    }
}

extension URL: JSONDecodeable {
    typealias JsonType = String
    init(json: JsonType) throws {
        guard let url = URL(string: json) else { throw ParserError.couldNotParse }
        self = url
    }
}

protocol JSONDecodeable: URLResponseDecodeable {
    associatedtype JsonType
    init(json: JsonType) throws
}

extension JSONDecodeable  {
    init(responseParams: NSURLSessionCompletionHandlerParams) throws {
        guard let data = responseParams.data else { throw ParserError.couldNotParse }
        let json: JsonType = try {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let expectedTypeJson = json as? JsonType else { throw ParserError.invalidJsonType }
                return expectedTypeJson
            } catch let error {
                throw ParserError.invalidJson(error: error)
            }
            }()
        try self.init(json: json)
    }
}
