//
//  ViewController.swift
//  Ripe
//
//  Created by Jedd Goble on 9/18/18.
//  Copyright © 2018 Jedd Goble. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cardWidth: CGFloat = 300.0
        let originX = view.frame.width / 2.0 - cardWidth / 2.0
        let cardViewFrame = CGRect(x: originX, y: 200.0, width: cardWidth, height: 400.0)
        let cardView = RipeCardView(frame: cardViewFrame, backgroundImage: UIImage(named: "dog.jpg"), overlayDisplayType: .colorOnly, shouldShowBorder: true)
        let ripeView = RipeContainerView(withFrame: view.frame, andCardView: cardView, withCardViewFrame: cardViewFrame)
        view.addSubview(ripeView)
    }

}

