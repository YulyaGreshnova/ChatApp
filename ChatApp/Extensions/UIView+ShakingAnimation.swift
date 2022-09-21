//
//  UIView+ShakingAnimation.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 29.04.2022.
//

import UIKit

extension UIView {
    private struct Constants {
        static let startingShakingAnimationGroup = "startingShakingAnimationGroup"
        static let finishingShakingAnimationGroup = "finishingShakingAnimationGroup"
    }
    
    func startShakingAnimation() {
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        rotationAnimation.values = [Double.pi / 10, 0, -Double.pi / 10]
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        let currentPosition = self.layer.position
        let left = CGPoint(x: currentPosition.x - 5, y: currentPosition.y)
        let right = CGPoint(x: currentPosition.x + 5, y: currentPosition.y)
        let down = CGPoint(x: currentPosition.x, y: currentPosition.y - 5)
        let up = CGPoint(x: currentPosition.x, y: currentPosition.y + 5)
        positionAnimation.values = [left, down, right, up]
     
        let startingShakingAnimationGroup = CAAnimationGroup()
        startingShakingAnimationGroup.duration = 0.3
        startingShakingAnimationGroup.repeatCount = .infinity
        startingShakingAnimationGroup.autoreverses = true
        startingShakingAnimationGroup.animations = [rotationAnimation, positionAnimation]
        startingShakingAnimationGroup.isRemovedOnCompletion = true
        self.layer.add(startingShakingAnimationGroup, forKey: Constants.startingShakingAnimationGroup)
    }
    
    func stopShakingAnimation() {
        self.layer.removeAnimation(forKey: Constants.startingShakingAnimationGroup)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        let currentValue = self.layer.presentation()?.value(forKeyPath: "transform.rotation")
        rotationAnimation.fromValue = currentValue
        rotationAnimation.toValue = 0

        let positionAnimation = CABasicAnimation(keyPath: "position")
        let currentPosition = self.layer.presentation()?.value(forKeyPath: "position")
        positionAnimation.fromValue = currentPosition
        positionAnimation.toValue = self.layer.position

        let finishingShakingAnimationGroup = CAAnimationGroup()
        finishingShakingAnimationGroup.duration = 0.3
        finishingShakingAnimationGroup.animations = [rotationAnimation, positionAnimation]
        finishingShakingAnimationGroup.isRemovedOnCompletion = true

        self.layer.add(finishingShakingAnimationGroup, forKey: Constants.finishingShakingAnimationGroup)
    }
}
