//
//  RipeCardView.swift
//  Ripe
//
//  Created by Jedd Goble on 9/18/18.
//  Copyright © 2018 Jedd Goble. All rights reserved.
//

import UIKit

enum OverlayDisplayType {
    case none
    case image
    case color
}

class RipeCardView: UIView {

    // MARK: Public Properties
    
    var configuration: RipeCardConfiguration = RipeCardConfiguration.zero
    
    // MARK: Read-Only Properties
    
    private(set) var percentComplete: CGFloat = 0.0
    
    // MARK: Private Properties
    
    private weak var parentView: RipeContainerView?
    private var backgroundImageView: UIImageView?
    private var overlayImageView: UIImageView?
    
    // MARK: Initialization
    
    required init(configuration: RipeCardConfiguration) {
        
        let cardViewFrame = CGRect(origin: .zero, size: configuration.size)
        super.init(frame: cardViewFrame)
        
        setup(withConfiguration: configuration)
    }
    
    private func setup(withConfiguration configuration: RipeCardConfiguration) {
        
        self.configuration = configuration
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 30.0
        clipsToBounds = true
        
        let backgroundImageView = UIImageView(frame: frame)
        backgroundImageView.frame.origin = CGPoint(x: 0.0, y: 0.0)
        backgroundImageView.backgroundColor = .clear
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = configuration.backgroundImage
        addSubview(backgroundImageView)
        sendSubview(toBack: backgroundImageView)
        
        let overlay = UIImageView(frame: frame)
        overlay.frame.origin = CGPoint(x: 0.0, y: 0.0)
        overlay.backgroundColor = .clear
        addSubview(overlay)
        bringSubview(toFront: overlay)
        overlay.isUserInteractionEnabled = false
        self.overlayImageView = overlay
        
        if configuration.shouldShowBorder == true {
            layer.borderColor = UIColor.black.cgColor
            layer.borderWidth = configuration.borderWidth
        } else {
            layer.borderColor = UIColor.clear.cgColor
            layer.borderWidth = 0.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Update Card Functions
    
    func updatePercentComplete(percentComplete: CGFloat) {
        self.percentComplete = percentComplete
        
        updateOverlay(percentComplete: percentComplete)
    }
    
    private func updateOverlay(percentComplete: CGFloat) {
        
        switch configuration.overlayDisplayType {
        case .none:
            if let overlay = overlayImageView { overlay.isHidden = true }
            break
        case .image:
            updateOverlayImage(percentComplete: percentComplete)
        case .color:
            overlayImageView?.image = nil
            updateOverlayColor(percentComplete: percentComplete)
        }
    }
    
    private func updateOverlayImage(percentComplete: CGFloat, leftTintColor: UIColor? = nil, rightTintColor: UIColor? = nil) {
        
        guard let overlay = overlayImageView else {
            return
        }
        
        overlay.backgroundColor = .clear
        overlay.isHidden = false
        
        if let leftImage = configuration.leftImage, percentComplete < 0.0 {
            overlay.image = leftImage
            overlay.layer.opacity = Float(abs(percentComplete))
            
        } else if let rightImage = configuration.rightImage, percentComplete > 0.0 {
            overlay.image = rightImage
            overlay.layer.opacity = Float(abs(percentComplete))
            
        } else {
            overlay.image = nil
            overlay.layer.opacity = 0.0
            overlay.tintColor = .clear
        }
    }
    
    private func updateOverlayColor(percentComplete: CGFloat) {
        
        guard let overlay = overlayImageView else {
            return
        }
        
        overlay.image = nil
        overlay.isHidden = false
        
        if percentComplete < 0.0 {
            overlay.backgroundColor = configuration.leftColor
            overlay.layer.opacity = Float(abs(percentComplete))
        } else if percentComplete > 0.0 {
            overlay.backgroundColor = configuration.rightColor
            overlay.layer.opacity = Float(abs(percentComplete))
        } else {
            overlay.backgroundColor = .clear
            overlay.layer.opacity = 0.0
        }
    }
    
}
