//
//  ViewController.swift
//  Ripe
//
//  Created by Jedd Goble on 9/18/18.
//  Copyright © 2018 Jedd Goble. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dogs: [String] = ["dog1.jpg", "dog2.jpg", "dog3.jpg", "dog4.jpg", "dog5.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ripeView = RipeContainerView(frame: view.frame)
        ripeView.dataSource = self
        view.addSubview(ripeView)
    }
}

extension ViewController: RipeDataSource {
    
    func nibNameForCardView() -> String {
        // TODO
        return ""
    }
    
    func nextCard(forNumberOfCardsShown cardsShown: Int) -> RipeCardView {
        
        var configuration = RipeCardConfiguration(size: CGSize(width: 200.0, height: 300.0))
        
        var backgroundImage: UIImage?
        
        if dogs.count > cardsShown {
            backgroundImage = UIImage(named: dogs[cardsShown])
        }
        
        configuration.backgroundImage = backgroundImage
        let card = RipeCardView(configuration: configuration)
        return card
    }
    
    func numberOfCardsToQueue() -> Int {
        return dogs.count
    }
}
