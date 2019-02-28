//
//  GokuAlertViewController.swift
//  Goku
//
//  Created by shiwei on 2019/2/15.
//

import UIKit

protocol GokuAlertAnimationType {
    func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning)
    func dismissAnimateTransition(using transitionContext: UIViewControllerContextTransitioning)
}

class GokuAlertViewController: UIViewController {
    
    private let setting: GokuAlertSetting
    
    private lazy var rootView: GokuAlertRootView = {
        return GokuAlertRootView(setting: setting)
    }()
    
    init(setting: GokuAlertSetting) {
        self.setting = setting
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

// MARK: Animation
extension GokuAlertViewController: GokuAlertAnimationType {
    func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        rootView.presentAnimateTransition(using: transitionContext)
    }
    
    func dismissAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        rootView.dismissAnimateTransition(using: transitionContext)
    }
}
