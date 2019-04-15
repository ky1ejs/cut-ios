//
//  Trailer.swift
//  Cut
//
//  Created by Kyle McAlpine on 16/11/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import Foundation

struct Trailer: JSONDecodeable {
    let url: URL
    let quality: VideoQuality
    let previewImageURL: URL
}

extension Trailer: AutoEquatable {}

enum VideoQuality: String, JSONDecodeable {
    case low
    case medium
    case high
    case hd
}
