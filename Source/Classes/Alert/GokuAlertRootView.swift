//
//  GokuAlertRootView.swift
//  Goku
//
//  Created by shiwei on 2019/2/15.
//

import UIKit

class GokuAlertRootView: UIView {
    
    private let setting: GokuAlertSetting
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffectView = UIVisualEffectView(effect: nil)
        return blurEffectView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    init(frame: CGRect = .zero, setting: GokuAlertSetting) {
        self.setting = setting
        super.init(frame: frame)
    }
    
    @available(*, unavailable, message: "Loading this view from a nib is unsupported")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        constructViewHierarchy()
        activateConstraints()
    }

}

extension GokuAlertRootView: GokuAlertAnimationType {
    func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if case .actionSheet = setting.style {
            contentView.transform = CGAffineTransform(translationX: 0, y: contentView.bounds.height)
        } else {
            contentView.alpha = 0.0
            contentView.center = center
            contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
        UIView.animate(withDuration: setting.animation.presentAnimationDuration, animations: {
            self.blurEffectView.effect = UIBlurEffect(style: self.setting.theme.blurEffectStyle)
            switch self.setting.style {
            case .actionSheet:
                let bounce = self.contentView.bounds.height / 4800.0 + 10
                self.contentView.transform = CGAffineTransform(translationX: 0, y: -bounce)
            case .alert:
                self.contentView.alpha = 1.0
                self.contentView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.contentView.transform = .identity
            }, completion: { (finished) in
                if finished { transitionContext.completeTransition(true) }
            })
        }
    }
    
    func dismissAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        UIView.animate(withDuration: setting.animation.dismissAnimationDuration, animations: {
            self.blurEffectView.effect = nil
            switch self.setting.style {
            case .alert:
                self.contentView.alpha = 0.0
                self.contentView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            case .actionSheet:
                self.contentView.transform = CGAffineTransform(translationX: 0, y: self.contentView.bounds.height)
            }
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}

/// 
extension GokuAlertRootView {
    private func constructViewHierarchy() {
        addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(contentView)
    }
    
    private func activateConstraints() {
        activateBlurEffectViewConstraints()
        activateContentViewConstraints()
    }
    
    private func activateBlurEffectViewConstraints() {
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = blurEffectView.topAnchor.constraint(equalTo: topAnchor)
        let bottom = blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leading = blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor)
        
        NSLayoutConstraint.activate([top, leading, bottom, trailing])
    }
    
    private func activateContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
}
