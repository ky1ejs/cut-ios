//
//  CutQrCodeImageDownloadRequestModifier.swift
//  Cut
//
//  Created by Kyle McAlpine on 18/01/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import UIKit
import Kingfisher

struct CutQrCodeImageDownloadRequestModifier {}

extension CutQrCodeImageDownloadRequestModifier: ImageDownloadRequestModifier {
    func modified(for request: URLRequest) -> URLRequest? {
        var request = request
        request.setValue(UIDevice.current.cutID, forHTTPHeaderField: "device_id")
        return request
    }
}
    
 