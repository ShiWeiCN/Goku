//
//  GokuAnimation.swift
//  Goku
//
//  Created by shiwei on 2019/2/14.
//

import UIKit

class GokuAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let isPresent: Bool
    private let setting: GokuAlertSetting
    
    init(_ isPresent: Bool, setting: GokuAlertSetting) {
        self.isPresent = isPresent
        self.setting = setting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresent ? setting.animation.presentAnimationDuration : setting.animation.dismissAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            presentAnimateTransition(using: transitionContext)
        } else {
            dismissAnimateTransition(using: transitionContext)
        }
    }
    
    private func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let alertControllerType = transitionContext.viewController(forKey: .to) as? GokuAlertAnimationType
            else {
                assertionFailure("The view controller will be presented needs to conform GokuAlertViewControllerType protocol.")
                return
            }
        alertControllerType.presentAnimateTransition(using: transitionContext)
    }
    
    private func dismissAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let alertControllerType = transitionContext.viewController(forKey: .from) as? GokuAlertAnimationType
            else {
                assertionFailure("The view controller needs tp conform GokuAlertViewControllerType protocol.")
                return
            }
        alertControllerType.dismissAnimateTransition(using: transitionContext)
    }
}
