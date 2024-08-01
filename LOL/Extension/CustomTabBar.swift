//
//  CustomTabBar.swift
//  CustomTabbarController
//
//  Created by Arpit iOS Dev. on 13/07/24.
//

import UIKit

class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 60
        return sizeThatFits
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = self.frame
        frame.origin.y = self.superview!.frame.height - frame.height - 34
        frame.origin.x = 17
        frame.size.width = self.superview!.frame.width - 35
        self.frame = frame
        
        applyGradient(colors: [UIColor(hex: "#FA4957").cgColor, UIColor(hex: "#FD7E41").cgColor])
        
        roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 30)
    }
    
    func applyGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

}

class CustomTabbarController : UITabBarController {
    
    
    
}
