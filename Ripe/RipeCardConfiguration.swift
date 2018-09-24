//
//  RipeCardConfiguration.swift
//  Ripe
//
//  Created by Jedd Goble on 9/24/18.
//  Copyright © 2018 Jedd Goble. All rights reserved.
//

import UIKit

struct RipeCardConfiguration {
    var size: CGSize
    var backgroundImage: UIImage? = nil
    var shouldShowBorder: Bool = true
    var borderWidth: CGFloat = 5.0
    var overlayDisplayType: OverlayDisplayType = .color
    var leftColor: UIColor = .red
    var rightColor: UIColor = .green
    var leftImage: UIImage? = nil
    var rightImage: UIImage? = nil
    
    init(size: CGSize) {
        self.size = size
    }
    
    static var zero = RipeCardConfiguration(size: .zero)
}
