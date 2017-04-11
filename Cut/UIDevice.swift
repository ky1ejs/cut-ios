//
//  UIDevice.swift
//  Cut
//
//  Created by Kyle McAlpine on 11/04/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

extension UIDevice {
    var cutID: String { return "ios_\(identifierForVendor!.uuidString)" }
}
