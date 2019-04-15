//
//  JSON.swift
//  Cut
//
//  Created by Kyle McAlpine on 23/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

protocol JSONDecodeable: URLResponseDecodeable, Decodable {}
extension JSONDecodeable {
    init(responseParams: NSURLSessionCompletionHandlerParams) throws {
        guard let data = responseParams.data else { throw ParserError.couldNotParse }
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}

protocol CustomJSONDecodable: URLResponseDecodeable {
    associatedtype JsonType
    init(json: JsonType) throws
}
extension CustomJSONDecodable {
    init(responseParams: NSURLSessionCompletionHandlerParams) throws {
        guard let data = responseParams.data else { throw ParserError.couldNotParse }
        let json: JsonType = try {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let expectedTypeJson = json as? JsonType else { throw     ParserError.invalidJsonType }
                return expectedTypeJson
            } catch let error {
                throw ParserError.invalidJson(error: error)
            }
        }()
        try self.init(json: json)
    }
}

extension Dictionary {
    func parse<T>(key: Key) throws -> T {
        guard let value = self[key] as? T else { throw ParserError.couldNotParse }
        return value
    }

    func parseDecodable<T: CustomJSONDecodable>(key: Key) throws -> T {
        guard let json = self[key] as? T.JsonType else { throw ParserError.couldNotParse }
        return try T(json: json)
    }

    func tryParse<T>(key: Key) -> T? {
        return self[key] as? T
    }

    func parseDecodable<T: CustomJSONDecodable>(key: Key) -> T? {
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

extension KeyedDecodingContainer {
    func decode<T>(key: Key) throws -> T where T: Decodable {
        return try decode(T.self, forKey: key)
    }
}

//extension URL: JSONDecodeable {
//    typealias JsonType = String
//    init(json: JsonType) throws {
//        guard let url = URL(string: json) else { throw ParserError.couldNotParse }
//        self = url
//    }
//}

//protocol JSONDecodeable: URLResponseDecodeable {
//    associatedtype JsonType
//    init(json: JsonType) throws
//}

