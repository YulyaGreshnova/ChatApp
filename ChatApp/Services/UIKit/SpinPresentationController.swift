//
//  SpinPresentationController.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 04.05.2022.
//

import UIKit

final class SpinPresentationController: NSObject {
    private let animationDuration: Double
    private let animationType: AnimationType
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension SpinPresentationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        TimeInterval(exactly: animationDuration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        switch animationType {
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            presentAnimation(with: transitionContext, viewToAnimate: toViewController.view)
        case .dismiss:
            transitionContext.containerView.addSubview(fromViewController.view)
            dismissAnimation(with: transitionContext, viewToAnimate: fromViewController.view)
        }
    }
    
    private func dismissAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        let duration = transitionDuration(using: transitionContext)
        let scale = CGAffineTransform(scaleX: 0.4, y: 0.4)
        let moveOut = CGAffineTransform(translationX: 0, y: -viewToAnimate.frame.height)

        UIView.animateKeyframes(withDuration: duration,
                                delay: 0,
                                options: .calculationModeLinear) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5 ) {
                viewToAnimate.transform = scale
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5 ) {
                viewToAnimate.transform = scale.concatenating(moveOut)
                viewToAnimate.alpha = 0
            }
        } completion: { _ in
            transitionContext.completeTransition(true)
        }

    }
    
    private func presentAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        viewToAnimate.clipsToBounds = true
        viewToAnimate.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        let duration = transitionDuration(using: transitionContext)
        let angel = CGFloat.pi * 2
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = angel
     
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1

        let group = CAAnimationGroup()
        group.animations = [rotateAnimation, scaleAnimation]
        group.duration = duration
        group.isRemovedOnCompletion = true
        
        viewToAnimate.layer.add(group, forKey: "rotation")
        viewToAnimate.layer.transform = CATransform3DMakeRotation(angel, 0, 0, 1)
        CATransaction.setDisableActions(true)
        CATransaction.setCompletionBlock {
            transitionContext.completeTransition(true)
        }
    }
}
