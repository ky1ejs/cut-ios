//
//  Trailer.swift
//  Cut
//
//  Created by Kyle McAlpine on 16/11/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct Trailer {
    let url: URL
    let quality: VideoQuality
    let previewImageURL: URL
}

extension Trailer: JSONDecodeable {
    typealias JsonType = [String : Any]
    init(json: JsonType) throws {
        url = try json.parseDecodable(key: "url")
        quality = try json.parseDecodable(key: "quality")
        previewImageURL = try json.parseDecodable(key: "preview_image_url")
    }
}

enum VideoQuality {
    case low
    case medium
    case high
    case hd
}

extension VideoQuality: JSONDecodeable {
    typealias JsonType = String
    init(json: JsonType) throws {
        switch json {
        case "low":     self = .low
        case "medium":  self = .medium
        case "high":    self = .high
        case "hd":      self = .hd
        default:        throw ParserError.couldNotParse
        }
    }
}
