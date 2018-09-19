//
//  RipeContainerView.swift
//  Ripe
//
//  Created by Jedd Goble on 9/18/18.
//  Copyright © 2018 Jedd Goble. All rights reserved.
//

import UIKit

enum SwipeResult {
    case left
    case right
    case cancelled
}

protocol RipeDelegate {
    func isSwiping(percentageComplete: CGFloat)
    func didReleaseSwipe(result: SwipeResult)
}

class RipeContainerView: UIView {

    // MARK: Initialization
    
    required init(withFrame frame: CGRect, andCardView cardView: RipeCardView, withCardViewFrame cardViewFrame: CGRect) {
        super.init(frame: frame)
        
        self.cardView = cardView
        
        self.cardView?.frame = cardViewFrame
        addSubview(cardView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Public Properties
    
    var edgeSize: CGFloat = 0.25 {
        didSet {
            
        }
    }
    
    var requiredVelocity: CGFloat = 5.0 {
        didSet {
            if requiredVelocity < 0.0 {
                requiredVelocity = -requiredVelocity
            }
        }
    }
    
    var rotationAmountFactor: Double = 0.5 {
        didSet {
            if rotationAmountFactor < 0.0 {
                rotationAmountFactor = 0.0
            }
            
            if rotationAmountFactor > 1.0 {
                rotationAmountFactor = 1.0
            }
        }
    }
    
    // MARK: Delegate
    
    var delegate: RipeDelegate?
    
    // MARK: Private Properties
    
    private var cardView: RipeCardView?
    
    private var initialTouchLocation: CGPoint?
    private var lastTouchLocation: CGPoint?
    
    private var rotationMinDegrees: CGFloat = 0.0
    private var rotationMaxDegrees: CGFloat = 180.0
    
    private var velocityMin: CGFloat = 1.0
    private var velocityMax: CGFloat = 1000.0
    private var currentVelocity: CGFloat?
    
    // MARK: Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if initialTouchLocation == nil {
            initialTouchLocation = touches.first?.location(in: self)
            lastTouchLocation = touches.first?.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let currentTouchLocation = touches.first?.location(in: self) else {
            delegate?.didReleaseSwipe(result: .cancelled)
            return
        }
        
        if let lastTouchLocation = lastTouchLocation {
            currentVelocity = currentTouchLocation.x - lastTouchLocation.x
        }
        
        lastTouchLocation = currentTouchLocation
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let cardVelocity = currentVelocity else {
            delegate?.didReleaseSwipe(result: .cancelled)
            return
        }
    }

}
