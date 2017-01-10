//  AlertView.swift
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

#if os(iOS)
    import UIKit
#endif

public typealias AlertTapColsure = (_ index: Int) -> Void

private struct Handler {
    static let BaseTag: Int = 9789
}

private extension Selector {
    static let alertActionButtonTapped = #selector(AlertView.buttonTapped(_:))
    static let handleContainerViewTapGesture = #selector(AlertView.handleContainerViewTapGesture(_:))
}

public class AlertView: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {
    
    // Message
    fileprivate var message: String?
    
    fileprivate var theme: AlertTheme!
    
    fileprivate var tappedButtonClosure: AlertTapColsure?
    
    // AlertController Style
    fileprivate(set) var preferredStyle: AlertViewStyle = .actionSheet
    
    // OverlayView
    fileprivate(set) var overlayView = UIView()
    fileprivate var overlayColor: UIColor {
        get {
            return self.theme.overlayColor
        }
    }
    
    // ContainerView
    fileprivate(set) var containerView = UIView()
    fileprivate var containerViewBottomSpaceConstraint: NSLayoutConstraint!
    
    // AlertView
    fileprivate(set) var alertView = UIView()
    fileprivate var alertViewWidth: CGFloat = .alertViewWidth
    fileprivate var alertViewPadding: CGFloat = .alertViewPadding
    fileprivate var innerContentWidth: CGFloat = .innerContentWidth
    fileprivate var innerContentWidthPadding: CGFloat = .innerContentWidthPadding
    fileprivate var innerButtonWidth: CGFloat = .innerButtonWidth
    fileprivate var actionSheetBounceHeight: CGFloat = .actionSheetBounceHeight
    
    fileprivate var alertViewHeightConstraint: NSLayoutConstraint!
    
    fileprivate var alertViewBackgroundColor: UIColor {
        get {
            return self.theme.backgroundColor
        }
    }
    
    // Customize View
    var customizeView = UIView()
    fileprivate var customizeViewPadding: CGFloat = .customizeViewPadding
    
    // IconImageView
    fileprivate var diffIcon: Bool = false
    fileprivate var iconImageView: UIImageView = UIImageView()
    fileprivate var iconBackgroundView: UIView = UIView()
    fileprivate var circleView: UIView = UIView()
    fileprivate var hasIconTopPadding: CGFloat {
        get {
            return self.diffIcon ? 8.0 : 0.0
        }
    }
    fileprivate var textAreaHeightPadding: CGFloat {
        get {
            return self.diffIcon ? CGFloat.circleSize / 2.0 + self.hasIconTopPadding : 0.0
        }
    }
    fileprivate var textAreaPadding: CGFloat {
        get {
            return self.diffIcon ? 10.0 : 0.0
        }
    }
    
    // TextAreaScrollView
    fileprivate var textAreaScrollView = UIScrollView()
    fileprivate var textAreaHeight: CGFloat = 0.0
    
    // TextAreaView
    fileprivate var textAreaView: UIView = UIView()
    
    // TextContainer
    fileprivate var textContainer = UIView()
    fileprivate var textContainerHeightConstraint: NSLayoutConstraint!
    
    // TitleLabel
    fileprivate var titleLabel = UILabel()
    fileprivate var titleFont: UIFont {
        get {
            return self.theme.titleFont
        }
    }
    fileprivate var titleTextColor: UIColor {
        get {
            return self.theme.titleColor
        }
    }
    
    // MessageView
    fileprivate var messageView = UILabel()
    fileprivate var messageFont: UIFont {
        get {
            return self.theme.messageFont
        }
    }
    fileprivate var messageTextColor: UIColor {
        get {
            return self.theme.messageColor
        }
    }
    
    // ButtonAreaScrollView
    fileprivate var buttonAreaScrollView = UIScrollView()
    fileprivate var buttonAreaScrollViewHeightConstraint: NSLayoutConstraint!
    fileprivate var buttonAreaHeight: CGFloat = 0.0
    
    // ButtonAreaView
    fileprivate var buttonAreaView = UIView()
    
    // ButtonContainer
    fileprivate var buttonContainer = UIView()
    fileprivate var buttonContainerHeightConstraint: NSLayoutConstraint!
    fileprivate var buttonHeight: CGFloat {
        get {
            return self.diffIcon ? 40.0 : 44.0
        }
    }
    fileprivate var buttonMargin: CGFloat = 8.0
    
    // Buttons
    fileprivate var buttons = [UIButton]()
    fileprivate var buttonStyles = [AlertItemStyle]()
    
    fileprivate var buttonCornerRadius: CGFloat {
        get {
            return self.theme.shape.cornerRadius
        }
    }
    
    fileprivate var layoutFlg = false
    fileprivate var keyboardHeight: CGFloat = 0.0
    fileprivate var cancelButtonTag = 0
    
    /**
     AlertView init Method
     
     - author: Shi Wei
     - date: 16-08-09 18:08:21
     
     - parameter theme:             theme
     - parameter preferredStyle:    .ActionSheet / /Alert
     - parameter title:             Title
     - parameter message:           SubTitle / Message
     - parameter cancelButton:      Cancel Button (AlertItemStyle)
     - parameter destructiveButton: Destructive Button (AlertItemStyle)
     - parameter otherButtons:      Others Button (Array[AlertItemStyle])
     - parameter tapClosure:        Tapped Closure
     
     AlertItemStyle => .Default(String, ButtonTitleColor, ButtonBackgroundColor) / .Cancel(String) / .Destructive(String)
     
     */
    internal convenience init(with theme: AlertTheme,
                          preferredStyle: AlertViewStyle,
                                   title: String?,
                                 message: String?,
                            cancelButton: AlertItemStyle,
                       destructiveButton: AlertItemStyle?,
                            otherButtons: [AlertItemStyle],
                              tapClosure: AlertTapColsure?) {
        
        self.init(nibName: nil, bundle: nil)
        
        settings()
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
        
        if case .alert(category: let category) = preferredStyle, category != .normal {
            diffIcon = true
            iconImageView.image = category.icon()
            iconBackgroundView.backgroundColor = category.tintColor()
            iconImageView.contentMode = .scaleAspectFill
        }
        
        self.theme = theme
        self.tappedButtonClosure = tapClosure
        sizeConfigure()
        configureSubView()
        
        if destructiveButton == nil {
            buttonStyles = [otherButtons, [cancelButton]].reduce([], +)
            buttons = addButtons(with: buttonStyles)
        } else {
            buttonStyles = [otherButtons, [destructiveButton!, cancelButton]].reduce([], +)
            buttons = addButtons(with: buttonStyles)
        }
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func isAlert() -> Bool {
        if case .alert = preferredStyle { return true }
        return false
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutSubView()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Add Gesture
        if (!isAlert() && cancelButtonTag != Int.baseTag) {
            let tap = UITapGestureRecognizer(target: self, action: .handleContainerViewTapGesture)
            tap.delegate = self
            containerView.addGestureRecognizer(tap)
        }
    }
    
    private func settings() {
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    private func sizeConfigure() {
        // Variable for ActionSheet
        if !isAlert() {
            alertViewWidth = CGSize.screenSize.width
            innerContentWidth = min(CGSize.screenSize.height, CGSize.screenSize.width)
        } else {
            alertView.layer.cornerRadius = self.theme.shape.cornerRadius
        }
        self.view.frame.size = CGSize.screenSize
    }
    
    // MARK: - Add buttons method
    fileprivate func addButtons(with buttons: [AlertItemStyle]) -> [UIButton] {
        // Add Button
        return buttons.map { (buttonStyle) -> UIButton in
            let button = UIButton(type: .custom)
            button.layer.masksToBounds = true
            button.setTitle(buttonStyle.buttonTitle, for: .normal)
            button.layer.cornerRadius = self.theme.shape.cornerRadius
            button.tag = Int.baseTag + (buttons.index { return $0.buttonTitle == buttonStyle.buttonTitle } ?? 0)
            switch buttonStyle {
            case .cancel(_): button.tag = Int.baseTag - 2
            case .destructive(_): button.tag = Int.baseTag - 1
            default: break
            }
            
            switch buttonStyle {
            case .cancel(_): button.addTarget(self, action: .handleContainerViewTapGesture, for: .touchUpInside)
            default: button.addTarget(self, action: .alertActionButtonTapped, for: .touchUpInside)
            }
            
            button.backgroundColor = buttonBackgroundColor(with: buttonStyle)
            button.setTitleColor(buttonTitleColor(with: buttonStyle), for: .normal)
            buttonContainer.addSubview(button)
            return button
        }
    }
    
    // MARK: - Button background color
    fileprivate func buttonBackgroundColor(with style: AlertItemStyle) -> UIColor {
        switch style {
            case .other(_): return self.theme.buttonBackgroundColor
            case .cancel(_): return self.theme.cancelButtonBackgroundColor
            case .destructive(_): return self.theme.destructBackgroundColor
        }
    }
    
    // MARK: - Button title color
    fileprivate func buttonTitleColor(with style: AlertItemStyle) -> UIColor {
        switch style {
            case .other(_): return self.theme.buttonTitleColor
            case .cancel(_): return self.theme.cancelButtonTitleColor
            case .destructive(_): return self.theme.destructTitleColor
        }
    }
    
    // MARK: - Layout
    fileprivate func layoutSubView() {
        if (layoutFlg) { return }
        layoutFlg = true
        
        //------------------------------
        // Layout & Color Settings
        //------------------------------
        overlayView.backgroundColor = overlayColor
        alertView.backgroundColor = alertViewBackgroundColor
        circleView.backgroundColor = alertViewBackgroundColor
        
        setIcon()
        setTextContent()
        setButtonArea()
        
        //------------------------------
        // AlertView Layout
        //------------------------------
        // AlertView Height
        reloadAlertViewHeight()
        alertView.frame.size = CGSize(width: alertViewWidth, height: alertViewHeightConstraint.constant + textAreaHeightPadding)
    }
    
    fileprivate func configure(item button: UIButton) {
        let style = buttonStyles[buttons.index(of: button) ?? 0]
        let backgroundColor = self.diffIcon ? self.getButtonBackgroundColor() : self.buttonBackgroundColor(with: style)
        
        button.titleLabel?.font = self.theme.buttonTitleFont
        button.titleLabel?.lineBreakMode = .byWordWrapping
        if diffIcon {
            button.setTitleColor(UIColor.white, for: .normal)
        }
        button.setBackgroundImage(createImage(with: backgroundColor), for: .normal)
        button.setBackgroundImage(createImage(with: backgroundColor), for: .highlighted)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
    }
    
    fileprivate func getButtonBackgroundColor() -> UIColor {
        // Button Background Color
        var buttonBackgroundColor: UIColor = UIColor()
        switch self.preferredStyle {
        case .alert(category: let category): buttonBackgroundColor = category.tintColor() ?? UIColor()
        default: break
        }
        return buttonBackgroundColor
    }
    
    private func setIcon() {
        // ICON
        if diffIcon {
            circleView.layer.cornerRadius = CGFloat.circleSize / 2.0
            iconBackgroundView.frame = CGRect(x: 0, y: 0, width: CGFloat.iconBackgroundViewSize, height: CGFloat.iconBackgroundViewSize)
            iconBackgroundView.center = CGPoint(x: CGFloat.circleSize / 2.0, y: CGFloat.circleSize / 2.0)
            iconBackgroundView.layer.cornerRadius = CGFloat.iconBackgroundViewSize / 2.0
            circleView.addSubview(iconBackgroundView)
            
            // ICON FRAME
            iconImageView.frame = CGRect(x: 0, y: 0, width: CGFloat.iconSize, height: CGFloat.iconSize)
            iconImageView.center = CGPoint(x: CGFloat.iconBackgroundViewSize / 2.0, y: CGFloat.iconBackgroundViewSize / 2.0)
            iconImageView.tintColor = self.theme.backgroundColor
            iconBackgroundView.addSubview(iconImageView)
        }
    }
    
    private func setTextContent() {
        //------------------------------
        // TextArea Layout
        //------------------------------
        let hasTitle: Bool = title != nil && title != ""
        let hasMessage: Bool = message != nil && message != ""
        
        var textAreaPositionY: CGFloat = alertViewPadding
        if (!isAlert()) { textAreaPositionY += alertViewPadding }
        
        // TitleLabel
        if (hasTitle) {
            self.configureTitle()
            titleLabel.frame = CGRect(x: innerContentWidthPadding, y: textAreaPositionY, width: innerContentWidth - 2 * innerContentWidthPadding, height: titleLabel.frame.height)
            textAreaPositionY += titleLabel.frame.height + 5.0
        }
        
        // MessageView
        if (hasMessage) {
            self.configureMessage()
            messageView.frame = CGRect(x: innerContentWidthPadding, y: textAreaPositionY, width: innerContentWidth - 2 * innerContentWidthPadding, height: messageView.frame.height)
            textAreaPositionY += messageView.frame.height + 5.0
        }
        
        if (!hasTitle && !hasMessage) {
            textAreaPositionY = 0.0
        }
        
        // TextAreaScrollView
        textAreaHeight = textAreaPositionY
        textAreaScrollView.contentSize = CGSize(width: alertViewWidth, height: textAreaHeight)
    }
    
    private func setButtonArea() {
        //------------------------------
        // ButtonArea Layout
        //------------------------------
        var buttonAreaPositionY: CGFloat = buttonMargin
        // Buttons
        if (isAlert() && buttons.count == 2) {
            let buttonWidth = (innerButtonWidth - buttonMargin) / 2
            var buttonPositionX: CGFloat = 0.0
            for button in buttons {
                self.configure(item: button)
                button.frame = CGRect(x: buttonPositionX, y: buttonAreaPositionY, width: buttonWidth, height: buttonHeight)
                buttonPositionX += buttonMargin + buttonWidth
            }
            buttonAreaPositionY += buttonHeight
        } else {
            let padding: CGFloat = self.isAlert() ? 0 : innerContentWidthPadding
            let width: CGFloat = self.isAlert() ? innerButtonWidth : (innerContentWidth - 2 * innerContentWidthPadding)
            var cancelHeight: CGFloat = 0.0
            for button in buttons {
                let style = buttonStyles[buttons.index(of: button) ?? 0]
                if case .cancel(_) = style {
                    cancelButtonTag = button.tag
                    cancelHeight = self.resetButtonHeight(with: style.buttonTitle)
                } else {
                    self.configure(item: button)
                    button.frame = CGRect(x: padding, y: buttonAreaPositionY, width: width, height: self.resetButtonHeight(with: style.buttonTitle))
                    buttonAreaPositionY += self.resetButtonHeight(with: style.buttonTitle) + buttonMargin
                }
            }
            // Cancel Button
            if (!isAlert() && buttons.count > 1) {
                buttonAreaPositionY += buttonMargin
            }
            let button = buttonAreaScrollView.viewWithTag(cancelButtonTag) as! UIButton
            self.configure(item: button)
            button.frame = CGRect(x: padding, y: buttonAreaPositionY, width: width, height: cancelHeight)
            buttonAreaPositionY += cancelHeight
        }
        buttonAreaPositionY += alertViewPadding
        if (buttons.count == 0) { buttonAreaPositionY = 0.0 }
        // ButtonAreaScrollView Height
        buttonAreaHeight = buttonAreaPositionY
        buttonAreaScrollView.contentSize = CGSize(width: alertViewWidth, height: buttonAreaHeight)
        buttonContainerHeightConstraint.constant = buttonAreaHeight
    }
    
    fileprivate func configureTitle() {
        titleLabel.frame.size    = CGSize(width: innerContentWidth - 2 * innerContentWidthPadding, height: 0.0)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font          = titleFont
        titleLabel.textColor     = titleTextColor
        titleLabel.text          = title
        titleLabel.sizeToFit()
        textContainer.addSubview(titleLabel)
    }
    
    fileprivate func configureMessage() {
        messageView.frame.size    = CGSize(width: innerContentWidth - 2 * innerContentWidthPadding, height: 0.0)
        messageView.numberOfLines = 0
        messageView.textAlignment = .center
        messageView.font          = messageFont
        messageView.textColor     = messageTextColor
        messageView.text          = message
        messageView.sizeToFit()
        textContainer.addSubview(messageView)
    }
    
    fileprivate func resetButtonHeight(with title: String) -> CGFloat {
        var result = buttonHeight
        if !isAlert() {
            let width: CGFloat = self.isAlert() ? innerButtonWidth : (innerContentWidth - 2 * innerContentWidthPadding)
            let offset = buttonHeight - CGFloat.singleLineHeight
            
            result = title.height(width, font: self.theme.buttonTitleFont, lineBreakMode: .byWordWrapping) + offset
        }
        return result
    }
    
    /**
     Show customize subView at aletView
     
     - author: Shi Wei
     - date: 16-07-31 12:07:21
     
     - parameter withSubView: customize subview
     */
    fileprivate func configureSubView(withSubView view: UIView) {
        self.layoutBackgroundView()
        
        containerView.addSubview(view)
        
        self.customizeView = view
        
        //------------------------------
        // Layout Constraint
        //------------------------------
        customizeView.translatesAutoresizingMaskIntoConstraints = false
        
        let customizeViewCenterXConstraint = NSLayoutConstraint(item: customizeView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let customizeViewCenterYConstraint = NSLayoutConstraint(item: customizeView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        containerView.addConstraints([customizeViewCenterXConstraint, customizeViewCenterYConstraint])
        
        // Customize View
        let screenSize = UIScreen.main.bounds.size
        let customizeViewWidth: CGFloat = view.frame.width > screenSize.width ? (screenSize.width - 2 * customizeViewPadding) : view.frame.width
        let customizeViewHeight: CGFloat = view.frame.width > screenSize.width ? (customizeViewWidth * view.frame.height / view.frame.width) : view.frame.height
        
        let customizeViewWidthConstraint = NSLayoutConstraint(item: customizeView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: customizeViewWidth)
        let customizeViewHeightConstraint = NSLayoutConstraint(item: customizeView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: customizeViewHeight)
        customizeView.addConstraints([
            customizeViewWidthConstraint,
            customizeViewHeightConstraint
            ])
    }
    
    private func addSubviews() {
        // AlertView
        containerView.addSubview(alertView)
        
        // Icon Image
        if self.diffIcon {
            alertView.addSubview(circleView)
        }
        // TextAreaScrollView
        alertView.addSubview(textAreaScrollView)
        // TextAreaView
        textAreaScrollView.addSubview(textAreaView)
        // TextContainer
        textAreaView.addSubview(textContainer)
        // ButtonAreaScrollView
        alertView.addSubview(buttonAreaScrollView)
        // ButtonAreaView
        buttonAreaScrollView.addSubview(buttonAreaView)
        // ButtonContainer
        buttonAreaView.addSubview(buttonContainer)
    }
    
    private func translaterAutoresizingMaskIntoConstraints() {
        //------------------------------
        // Layout Constraint
        //------------------------------
        alertView.translatesAutoresizingMaskIntoConstraints            = false
        circleView.translatesAutoresizingMaskIntoConstraints           = false
        textAreaScrollView.translatesAutoresizingMaskIntoConstraints   = false
        textAreaScrollView.translatesAutoresizingMaskIntoConstraints   = false
        textContainer.translatesAutoresizingMaskIntoConstraints        = false
        buttonAreaScrollView.translatesAutoresizingMaskIntoConstraints = false
        buttonAreaView.translatesAutoresizingMaskIntoConstraints       = false
        buttonContainer.translatesAutoresizingMaskIntoConstraints      = false
    }
    
    private func alertConstraint() {
        // ContainerView
        let alertViewCenterXConstraint = NSLayoutConstraint(item: alertView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let alertViewCenterYConstraint = NSLayoutConstraint(item: alertView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        containerView.addConstraints([alertViewCenterXConstraint, alertViewCenterYConstraint])
        
        // AlertView
        let alertViewWidthConstraint = NSLayoutConstraint(item: alertView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: alertViewWidth)
        alertViewHeightConstraint = NSLayoutConstraint(item: alertView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 1000.0)
        alertView.addConstraints([
            alertViewWidthConstraint,
            alertViewHeightConstraint])
        
        if self.diffIcon {
            let circleViewTopSpaceConstraint = NSLayoutConstraint(item: circleView, attribute: .top, relatedBy: .equal, toItem: alertView, attribute: .top, multiplier: 1.0, constant: -CGFloat.circleSize / 2.0)
            let circleViewCenterXConstraint = NSLayoutConstraint(item: circleView, attribute: .centerX, relatedBy: .equal, toItem: alertView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            alertView.addConstraints([
                circleViewTopSpaceConstraint,
                circleViewCenterXConstraint])
            
            // Circle View
            let circleViewHeightConstraint = NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: CGFloat.circleSize)
            let circleViewWidthConstraint = NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: CGFloat.circleSize)
            circleView.addConstraints([
                circleViewWidthConstraint,
                circleViewHeightConstraint])
        }
    }
    
    private func actionSheetConstrtaint() {
        // ContainerView
        let alertViewCenterXConstraint = NSLayoutConstraint(item: alertView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let alertViewBottomSpaceConstraint = NSLayoutConstraint(item: alertView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: actionSheetBounceHeight)
        let alertViewWidthConstraint = NSLayoutConstraint(item: alertView, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: 1.0, constant: 0.0)
        containerView.addConstraints([
            alertViewCenterXConstraint,
            alertViewBottomSpaceConstraint,
            alertViewWidthConstraint])
        
        // AlertView
        alertViewHeightConstraint = NSLayoutConstraint(item: alertView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 1000.0)
        alertView.addConstraint(alertViewHeightConstraint)
    }
    
    private func alertViewConstraint() {
        // MARK: - AlertView Constraint
        let textAreaScrollViewTopSpaceConstraint = NSLayoutConstraint(item: textAreaScrollView, attribute: .top, relatedBy: .equal, toItem: self.diffIcon ? circleView : alertView, attribute: self.diffIcon ? .bottom : .top, multiplier: 1.0, constant: self.hasIconTopPadding)
        let textAreaScrollViewRightSpaceConstraint = NSLayoutConstraint(item: textAreaScrollView, attribute: .right, relatedBy: .equal, toItem: alertView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let textAreaScrollViewLeftSpaceConstraint = NSLayoutConstraint(item: textAreaScrollView, attribute: .left, relatedBy: .equal, toItem: alertView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let textAreaScrollViewBottomSpaceConstraint = NSLayoutConstraint(item: textAreaScrollView, attribute: .bottom, relatedBy: .equal, toItem: buttonAreaScrollView, attribute: .top, multiplier: 1.0, constant: self.textAreaPadding)
        
        let buttonAreaScrollViewRightSpaceConstraint = NSLayoutConstraint(item: buttonAreaScrollView, attribute: .right, relatedBy: .equal, toItem: alertView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let buttonAreaScrollViewLeftSpaceConstraint = NSLayoutConstraint(item: buttonAreaScrollView, attribute: .left, relatedBy: .equal, toItem: alertView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let buttonAreaScrollViewBottomSpaceConstraint = NSLayoutConstraint(item: buttonAreaScrollView, attribute: .bottom, relatedBy: .equal, toItem: alertView, attribute: .bottom, multiplier: 1.0, constant: isAlert() ? 0.0 : -actionSheetBounceHeight)
        alertView.addConstraints([
            textAreaScrollViewTopSpaceConstraint,
            textAreaScrollViewLeftSpaceConstraint,
            textAreaScrollViewRightSpaceConstraint,
            textAreaScrollViewBottomSpaceConstraint,
            buttonAreaScrollViewRightSpaceConstraint,
            buttonAreaScrollViewLeftSpaceConstraint,
            buttonAreaScrollViewBottomSpaceConstraint])
    }
    
    private func textAreaConstraint() {
        // MARK: - TextAreaScrollView Constraint
        let textAreaViewTopSpaceConstraint = NSLayoutConstraint(item: textAreaView, attribute: .top, relatedBy: .equal, toItem: textAreaScrollView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let textAreaViewRightSpaceConstraint = NSLayoutConstraint(item: textAreaView, attribute: .right, relatedBy: .equal, toItem: textAreaScrollView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let textAreaViewLeftSpaceConstraint = NSLayoutConstraint(item: textAreaView, attribute: .left, relatedBy: .equal, toItem: textAreaScrollView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let textAreaViewBottomSpaceConstraint = NSLayoutConstraint(item: textAreaView, attribute: .bottom, relatedBy: .equal, toItem: textAreaScrollView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        textAreaScrollView.addConstraints([
            textAreaViewTopSpaceConstraint,
            textAreaViewRightSpaceConstraint,
            textAreaViewLeftSpaceConstraint,
            textAreaViewBottomSpaceConstraint])
        
        // MARK: - TextArea Constraint
        let textAreaViewHeightConstraint = NSLayoutConstraint(item: textAreaView, attribute: .height, relatedBy: .equal, toItem: textContainer, attribute: .height, multiplier: 1.0, constant: 0.0)
        let textContainerTopSpaceConstraint = NSLayoutConstraint(item: textContainer, attribute: .top, relatedBy: .equal, toItem: textAreaView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let textContainerLeftSpaceConstraint = NSLayoutConstraint(item: textContainer, attribute: .left, relatedBy: .equal, toItem: textAreaView, attribute: .left, multiplier: 1.0, constant: 0.0)
        textAreaView.addConstraints([textAreaViewHeightConstraint, textContainerTopSpaceConstraint, textContainerLeftSpaceConstraint])
        
        // MARK: - TextContainer Constraint
        let textContainerWidthConstraint = NSLayoutConstraint(item: textContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: alertViewWidth)
        textContainerHeightConstraint = NSLayoutConstraint(item: textContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.0)
        textContainer.addConstraints([textContainerWidthConstraint, textContainerHeightConstraint])
    }
    
    private func buttonAreaConstraint() {
        // MARK: - ButtonAreaScrollView Constraint
        buttonAreaScrollViewHeightConstraint = NSLayoutConstraint(item: buttonAreaScrollView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.0)
        let buttonAreaViewTopSpaceConstraint = NSLayoutConstraint(item: buttonAreaView, attribute: .top, relatedBy: .equal, toItem: buttonAreaScrollView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let buttonAreaViewLeftSpaceConstraint = NSLayoutConstraint(item: buttonAreaView, attribute: .left, relatedBy: .equal, toItem: buttonAreaScrollView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let buttonAreaViewWidthConstraint = NSLayoutConstraint(item: buttonAreaView, attribute: .width, relatedBy: .equal, toItem: buttonAreaScrollView, attribute: .width, multiplier: 1.0, constant: 0.0)
        let buttonAreaViewHeightConstraint = NSLayoutConstraint(item: buttonAreaView, attribute: .height, relatedBy: .equal, toItem: buttonAreaScrollView, attribute: .height, multiplier: 1.0, constant: 0.0)
        buttonAreaScrollView.addConstraints([buttonAreaScrollViewHeightConstraint, buttonAreaViewTopSpaceConstraint, buttonAreaViewLeftSpaceConstraint, buttonAreaViewWidthConstraint, buttonAreaViewHeightConstraint])
        
        // MARK: - ButtonArea Constraint
        let buttonContainerTopSpaceConstraint = NSLayoutConstraint(item: buttonContainer, attribute: .top, relatedBy: .equal, toItem: buttonAreaView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let buttonContainerCenterXConstraint = NSLayoutConstraint(item: buttonContainer, attribute: .centerX, relatedBy: .equal, toItem: buttonAreaView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        buttonAreaView.addConstraints([buttonContainerTopSpaceConstraint, buttonContainerCenterXConstraint])
        
        // MARK: - ButtonContainer Constraint
        let buttonContainerWidthConstraint = NSLayoutConstraint(item: buttonContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: self.isAlert() ? innerButtonWidth : innerContentWidth)
        buttonContainerHeightConstraint = NSLayoutConstraint(item: buttonContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: buttonHeight)
        buttonContainer.addConstraints([buttonContainerWidthConstraint, buttonContainerHeightConstraint])
    }
    
    /**
     Show subviews at alertView
     
     - author: Shi Wei
     - date: 16-07-31 12:07:51
     */
    fileprivate func configureSubView() {
        layoutBackgroundView()
        addSubviews()
        translaterAutoresizingMaskIntoConstraints()
        // MARK: - ContainerView && AlertView Constraint
        if (isAlert()) {
            alertConstraint()
        } else {
            actionSheetConstrtaint()
        }
        alertViewConstraint()
        textAreaConstraint()
        buttonAreaConstraint()
    }
    
    fileprivate func layoutBackgroundView() {
        
        // OverlayView
        self.view.addSubview(overlayView)
        // ContainerView
        self.view.addSubview(containerView)
        
        //------------------------------
        // Layout Constraint
        //------------------------------
        overlayView.translatesAutoresizingMaskIntoConstraints   = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // self.view
        let overlayViewTopSpaceConstraint = NSLayoutConstraint(item: overlayView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let overlayViewRightSpaceConstraint = NSLayoutConstraint(item: overlayView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0)
        let overlayViewLeftSpaceConstraint = NSLayoutConstraint(item: overlayView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0)
        let overlayViewBottomSpaceConstraint = NSLayoutConstraint(item: overlayView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let containerViewTopSpaceConstraint = NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let containerViewRightSpaceConstraint = NSLayoutConstraint(item: containerView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0)
        let containerViewLeftSpaceConstraint = NSLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0)
        containerViewBottomSpaceConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([
            overlayViewTopSpaceConstraint,
            overlayViewRightSpaceConstraint,
            overlayViewLeftSpaceConstraint,
            overlayViewBottomSpaceConstraint,
            containerViewTopSpaceConstraint,
            containerViewRightSpaceConstraint,
            containerViewLeftSpaceConstraint,
            containerViewBottomSpaceConstraint])
    }
    
    // Reload AlertView Height
    fileprivate func reloadAlertViewHeight() {
        
        var screenSize = UIScreen.main.bounds.size
        if ((UIDevice.current.systemVersion as NSString).floatValue < 8.0) {
            if (UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)) {
                screenSize = CGSize(width: screenSize.height, height: screenSize.width)
            }
        }
        let maxHeight = screenSize.height - keyboardHeight
        
        // For avoiding constraint error
        buttonAreaScrollViewHeightConstraint.constant = 0.0
        
        // AlertView Height Constraint
        var alertViewHeight = textAreaHeight + textAreaHeightPadding + buttonAreaHeight + self.textAreaPadding
        if (alertViewHeight > maxHeight) {
            alertViewHeight = maxHeight
        }
        if (!isAlert()) {
            alertViewHeight += actionSheetBounceHeight
        }
        alertViewHeightConstraint.constant = alertViewHeight
        
        // ButtonAreaScrollView Height Constraint
        var buttonAreaScrollViewHeight = buttonAreaHeight
        if (buttonAreaScrollViewHeight > maxHeight) {
            buttonAreaScrollViewHeight = maxHeight
        }
        buttonAreaScrollViewHeightConstraint.constant = buttonAreaScrollViewHeight
    }
    
    // Button Tapped Action
    func buttonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if let c = self.tappedButtonClosure {
            c(sender.tag - Int.baseTag)
        }
    }
    
    // Handle ContainerView tap gesture
    func handleContainerViewTapGesture(_ sender: AnyObject) {
        // cancel action
        self.dismiss(animated: true, completion: nil)
        if let c = self.tappedButtonClosure,
           let tag = sender.tag {
            c(tag - Int.baseTag)
        }
    }
    
}

extension AlertView: UIGestureRecognizerDelegate {
    
    // UIColor -> UIImage
    fileprivate func createImage(with color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let contextRef: CGContext = UIGraphicsGetCurrentContext()!
        contextRef.setFillColor(color.cgColor)
        contextRef.fill(rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
    
    // MARK: - UIViewControllerTransitioningDelegate Methods
    
    @objc(animationControllerForPresentedController:presentingController:sourceController:) public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        layoutSubView()
        return AlertAnimation(isPresenting: true)
    }
    
    @objc(animationControllerForDismissedController:) public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertAnimation(isPresenting: false)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIButton)
    }
    
}
