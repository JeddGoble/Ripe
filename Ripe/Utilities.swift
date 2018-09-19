//
//  Utilities.swift
//  Ripe
//
//  Created by Jedd Goble on 9/19/18.
//  Copyright © 2018 Jedd Goble. All rights reserved.
//

import UIKit

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension CGRect {
    var center: CGPoint { return CGPoint(x: self.origin.x + (self.width / 2.0), y: self.origin.y + self.height / 2.0)}
}
