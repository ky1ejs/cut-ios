//
//  AlertPresentationController.swift
//  Cut
//
//  Created by Kyle McAlpine on 24/12/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy

class AlertPresentationController: UIPresentationController {
    private let dimmingView: UIView = {
        let dv = UIView()
        dv.backgroundColor = .gray
        return dv
    }()
    
    override func presentationTransitionWillBegin() {
        dimmingView.alpha = 0
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        containerView?.addSubview(dimmingView)
        presentedView?.layer.cornerRadius = 20
        dimmingView.easy.layout(Edges())
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) -> Void in
            self.dimmingView.alpha = 0.4
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) -> Void in
            self.dimmingView.alpha = 0
        }, completion: { context in
            self.dimmingView.removeFromSuperview()
        })
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return parentSize
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame = CGRect.zero
        let containerSize = containerView!.bounds.size
        frame.size = CGSize(width: containerSize.width - 100, height: 300)
        frame.origin = CGPoint(x: (containerSize.width - frame.size.width) / 2, y: (containerSize.height - frame.size.height) / 2)
        return frame
    }
    
    @objc func dismiss() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
