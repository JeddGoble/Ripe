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
    func isSwiping(percentComplete: CGFloat)
    func didReleaseSwipe(result: SwipeResult)
    func didCompleteAnimation(result: SwipeResult)
}

class RipeContainerView: UIView {

    // MARK: Initialization
    
    required init(withFrame frame: CGRect, andCardView cardView: RipeCardView, withCardViewFrame cardViewFrame: CGRect) {
        super.init(frame: frame)
        
        self.cardView = cardView
        
        self.cardView?.frame = cardViewFrame
        self.initialFrame = cardView.frame
        addSubview(cardView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        backgroundColor = UIColor.clear
    }
    
    // MARK: Public Properties
    
    var requiredVelocity: CGFloat = 10.0 {
        didSet {
            if requiredVelocity < 0.0 {
                requiredVelocity = -requiredVelocity
            } else if requiredVelocity < velocityMin {
                requiredVelocity = velocityMin
            } else if requiredVelocity > velocityMax {
                requiredVelocity = velocityMax
            }
        }
    }
    
    var rotationDegrees: CGFloat = 45.0 {
        didSet {
            if rotationDegrees < 0.0 {
                rotationDegrees = 0.0
            } else if rotationDegrees > 360.0 {
                rotationDegrees = 360.0
            }
        }
    }
    
    // MARK: Delegate
    
    var delegate: RipeDelegate?
    
    // MARK: Private Properties
    
    private var cardView: RipeCardView?
    
    private var initialFrame: CGRect?
    private var initialTouchLocation: CGPoint?
    private var lastTouchLocation: CGPoint?
    
    private var rotationMinDegrees: CGFloat = 0.0
    private var rotationMaxDegrees: CGFloat = 180.0
    
    private var velocityMin: CGFloat = 1.0
    private var velocityMax: CGFloat = 1000.0
    private var currentVelocity: CGFloat?
    
    private var currentlyAnimating: Bool = false
    
    // MARK: Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard !currentlyAnimating else {
            return
        }
        
        if initialTouchLocation == nil {
            initialTouchLocation = touches.first?.location(in: self)
            lastTouchLocation = touches.first?.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let currentTouchLocation = touches.first?.location(in: self), let cardView = cardView, !currentlyAnimating else {
            delegate?.didReleaseSwipe(result: .cancelled)
            return
        }
        
        if let lastTouchLocation = lastTouchLocation {
            currentVelocity = currentTouchLocation.x - lastTouchLocation.x
        }
        
        if let initialCenter = initialFrame?.center, let initialTouchLocation = initialTouchLocation {
            
            let distanceDragged = currentTouchLocation.x - initialTouchLocation.x
            let percentComplete = distanceDragged / frame.width
            let rotationRadians = (rotationDegrees * percentComplete).degreesToRadians
            cardView.transform = CGAffineTransform(rotationAngle: rotationRadians)
            
            cardView.center.x = initialCenter.x + distanceDragged
            
            cardView.updatePercentComplete(percentComplete: percentComplete)
            delegate?.isSwiping(percentComplete: percentComplete)
        }
        
        lastTouchLocation = currentTouchLocation
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let cardVelocity = currentVelocity, !currentlyAnimating else {
            delegate?.didReleaseSwipe(result: .cancelled)
            return
        }
        
        if abs(cardVelocity) >= requiredVelocity {
            animateCardOffScreen(withVelocity: cardVelocity)
            
            let result: SwipeResult = cardVelocity < 0.0 ? .left : .right
            delegate?.didReleaseSwipe(result: result)
        } else {
            animateCardReturnToCenter()
            delegate?.didReleaseSwipe(result: .cancelled)
        }
        
        initialTouchLocation = nil
        
    }
    
    // MARK: Animation
    
    private func animateCardOffScreen(withVelocity velocity: CGFloat) {
        
        guard let cardView = cardView else {
            return
        }
        
        currentlyAnimating = true
        
        let result: SwipeResult = velocity < 0.0 ? .left : .right
        let endPointX = velocity < 0.0 ? -cardView.frame.width : frame.width + cardView.frame.width
        let rotationRadians = velocity < 0.0 ? -rotationDegrees.degreesToRadians : rotationDegrees.degreesToRadians
        
        UIView.animate(withDuration: 0.3, animations: {
            cardView.center = CGPoint(x: endPointX, y: cardView.center.y)
            cardView.transform = CGAffineTransform(rotationAngle: rotationRadians)
            cardView.updatePercentComplete(percentComplete: 1.0)
        }) { (completed) in
            self.currentlyAnimating = false
            self.delegate?.didCompleteAnimation(result: result)
        }
    }
    
    private func animateCardReturnToCenter() {
        
        guard let cardView = cardView, let initialFrame = initialFrame else {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            cardView.center = initialFrame.center
            cardView.transform = CGAffineTransform(rotationAngle: CGFloat(0.0).degreesToRadians)
            cardView.updatePercentComplete(percentComplete: 0.0)
        }) { (completed) in
            self.delegate?.didCompleteAnimation(result: .cancelled)
        }
        
    }

}
