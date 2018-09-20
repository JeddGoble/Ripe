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
    case imageOnly
    case colorOnly
    case imageAndColor
}

class RipeCardView: UIView {

    // MARK: Public Properties
    
    var backgroundImageView: UIImageView?
    var shouldShowBorder: Bool = true
    var overlayDisplayType: OverlayDisplayType = .colorOnly
    var leftColor: UIColor? = .red
    var rightColor: UIColor? = .green
    var leftImage: UIImage?
    var rightImage: UIImage?
    
    // MARK: Read-Only Properties
    
    private(set) var percentComplete: CGFloat = 0.0
    
    // MARK: Private Properties
    
    private var overlayImageView: UIImageView?
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup(frame: frame)
    }
    
    private func setup(frame: CGRect) {
        backgroundColor = UIColor.white
        layer.cornerRadius = 30.0
        clipsToBounds = true
        
        let backgroundImageView = UIImageView(frame: frame)
        backgroundImageView.frame.origin = CGPoint(x: 0.0, y: 0.0)
        backgroundImageView.backgroundColor = .clear
        addSubview(backgroundImageView)
        sendSubview(toBack: backgroundImageView)
        self.backgroundImageView = backgroundImageView
        
        let overlay = UIImageView(frame: frame)
        overlay.frame.origin = CGPoint(x: 0.0, y: 0.0)
        overlay.backgroundColor = .clear
        overlay.tintColor = .clear
        addSubview(overlay)
        bringSubview(toFront: overlay)
        overlay.isUserInteractionEnabled = false
        self.overlayImageView = overlay
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(frame: CGRect, backgroundImage: UIImage? = nil, cornerRadius: CGFloat = 30.0, overlayDisplayType: OverlayDisplayType = .colorOnly, leftColor: UIColor? = .red, rightColor: UIColor? = .green, leftImage: UIImage? = nil, rightImage: UIImage? = nil, shouldShowBorder: Bool = true) {
        self.init(frame: frame)
        
        self.overlayDisplayType = overlayDisplayType
        self.leftColor = leftColor
        self.rightColor = rightColor
        self.leftImage = leftImage
        self.rightImage = rightImage
        
        backgroundImageView?.image = backgroundImage
        
        if shouldShowBorder {
            layer.borderColor = UIColor.black.cgColor
            layer.borderWidth = 5.0
        } else {
            layer.borderColor = UIColor.clear.cgColor
            layer.borderWidth = 0.0
        }
    }
    
    // MARK: Update Card Functions
    
    func updatePercentComplete(percentComplete: CGFloat) {
        self.percentComplete = percentComplete
        
        updateOverlay(percentComplete: percentComplete)
    }
    
    private func updateOverlay(percentComplete: CGFloat) {
        
        switch overlayDisplayType {
        case .none:
            break
        case .imageOnly:
            updateOverlayImage(percentComplete: percentComplete)
        case .colorOnly:
            overlayImageView?.image = nil
            updateOverlayColor(percentComplete: percentComplete)
        case .imageAndColor:
            updateOverlayImage(percentComplete: percentComplete, leftTintColor: leftColor, rightTintColor: rightColor)
        }
    }
    
    private func updateOverlayImage(percentComplete: CGFloat, leftTintColor: UIColor? = nil, rightTintColor: UIColor? = nil) {
        
        guard let overlay = overlayImageView else {
            return
        }
        
        overlay.backgroundColor = .clear
        
        if let leftImage = leftImage, percentComplete < 0.0 {
            overlay.image = leftImage
            overlay.layer.opacity = Float(abs(percentComplete))
            
            if let leftTintColor = leftTintColor {
                overlay.tintColor = leftTintColor
            }
        } else if let rightImage = rightImage, percentComplete > 0.0 {
            overlay.image = rightImage
            overlay.layer.opacity = Float(abs(percentComplete))
            
            if let rightTintColor = rightTintColor {
                overlay.tintColor = rightTintColor
            }
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
        
        if percentComplete < 0.0 {
            overlay.backgroundColor = leftColor
            overlay.layer.opacity = Float(abs(percentComplete))
        } else if percentComplete > 0.0 {
            overlay.backgroundColor = rightColor
            overlay.layer.opacity = Float(abs(percentComplete))
        } else {
            overlay.backgroundColor = .clear
            overlay.layer.opacity = 0.0
        }
    }
    
}









































