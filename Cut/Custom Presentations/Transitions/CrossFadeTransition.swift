//
//  CrossFadeTransition.swift
//  Cut
//
//  Created by Kyle McAlpine on 24/12/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit

final class CrossFadeTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// The direction of the fade.
    ///
    /// - `in`: The target screen fades in on top of the origin screen.
    /// - out: The origin screen fades out to leave space to the target screen placed underneath it.
    enum Direction {
        case `in`
        case out
    }
    
    private let direction: Direction
    
    /// The designated initializer for the transition
    ///
    /// - Parameter direction: The direction of the transition.
    required init(direction: Direction) {
        self.direction = direction
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey = direction == .`in` ? .to : .from
        let controller = transitionContext.viewController(forKey: key)!
        
        if direction == .`in` {
            controller.view.frame = transitionContext.finalFrame(for: controller)
            transitionContext.containerView.addSubview(controller.view)
        }
        
        controller.view.alpha = direction == .`in` ? 0 : 1
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            switch self.direction {
            case .out:  controller.view.alpha = 0
            case .`in`: controller.view.alpha = 1
            }
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}
