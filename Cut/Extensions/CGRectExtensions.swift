//
//  CGRectExtensions.swift
//  Cut
//
//  Created by Kyle McAlpine on 18/06/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

extension CGRect {
    var center: CGPoint { return CGPoint(x: origin.x + (width / 2), y: origin.y + (height / 2)) }
}
