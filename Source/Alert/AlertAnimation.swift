//  AlertAnimation.swift
//  Goku (https://github.com/ShiWeiCN/Goku)
//
//
//  Copyright (c) 2017 shiwei (http://shiweicn.github.io/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

internal class AlertAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? 0.45 : 0.25
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if (isPresenting) {
            self.presentAnimateTransition(transitionContext)
        } else {
            self.dismissAnimateTransition(transitionContext)
        }
    }
    
    private func presentAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let alertController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! AlertView
        let containerView = transitionContext.containerView
        alertController.overlayView.alpha = 0.0
        if (alertController.isAlert()) {
            alertController.alertView.alpha = 0.0
            alertController.alertView.center = alertController.view.center
            alertController.alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        } else {
            alertController.alertView.transform = CGAffineTransform(translationX: 0, y: alertController.alertView.frame.height)
        }
        containerView.addSubview(alertController.view)
        UIView.animate(withDuration: 0.25, animations: {
            alertController.overlayView.alpha = 1.0
            if (alertController.isAlert()) {
                alertController.alertView.alpha = 1.0
                alertController.alertView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            } else {
                let bounce = alertController.alertView.frame.height / 480 * 10.0 + 10.0
                alertController.alertView.transform = CGAffineTransform(translationX: 0, y: -bounce)
            }
        }, completion: { finished in
            UIView.animate(withDuration: 0.2, animations: {
                alertController.alertView.transform = CGAffineTransform.identity
                }, completion: { finished in
                    if (finished) {
                        transitionContext.completeTransition(true)
                    }
            })
        }) 
    }
    
    private func dismissAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let alertController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! AlertView
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            alertController.overlayView.alpha = 0.0
            if (alertController.isAlert()) {
                alertController.alertView.alpha = 0.0
                alertController.alertView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            } else {
                alertController.containerView.transform = CGAffineTransform(translationX: 0, y: alertController.alertView.frame.height)
            }
            }, completion: { finished in
                transitionContext.completeTransition(true)
        })
    }
}
