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
        
        let centerX = view.frame.width / 2.0 - 150.0
        let cardViewFrame = CGRect(x: centerX, y: 200.0, width: 300.0, height: 400.0)
        let cardView = RipeCardView(frame: cardViewFrame)
        cardView.layer.cornerRadius = 30.0
        cardView.backgroundColor = UIColor(red: 0.0, green: 0.25, blue: 0.75, alpha: 1.0)
        let ripeView = RipeContainerView(withFrame: view.frame, andCardView: cardView, withCardViewFrame: cardViewFrame)
        view.addSubview(ripeView)
    }

}

