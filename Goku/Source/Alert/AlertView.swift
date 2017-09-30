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
    static let sharedCancelButtonTapped = #selector(AlertView.sharedCancelButtonTapped(_:))
}

final class AlertView: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {
    
    // MARK: - Message
    fileprivate var message: String?
    
    fileprivate(set) var theme: AlertTheme!
    
    fileprivate var tappedButtonClosure: AlertTapColsure?
    
    // MARK: - AlertController Style
    fileprivate(set) var preferredStyle: AlertViewStyle = .actionSheet(isShareable: false)
    
    // MARK: - BlurEffectView
    lazy fileprivate(set) var blurEffectView: UIVisualEffectView? = {
        if case AlertOverlay.blurEffect(let style) = self.theme.overlay {
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return blurEffectView
        }
        return nil
    }()
    
    // MARK: - OverlayView
    fileprivate(set) var overlayView = UIView()
    fileprivate var overlayColor: UIColor? {
        get {
            if case AlertOverlay.normal(let color) = self.theme.overlay {
                return color
            }
            return nil
        }
    }
    
    // MARK: - ContainerView
    fileprivate(set) var containerView = UIView()
    fileprivate var containerViewBottomSpaceConstraint: NSLayoutConstraint!
    
    // MARK: - AlertView
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
            if self.isShared { return .white }
            return self.theme.backgroundColor
        }
    }
    
    private var isShared: Bool = false
    
    // MARK: - Customize View
    var owner: UIView!
    fileprivate var ownerViewPadding: CGFloat = .ownerViewPadding
    
    // MARK: - IconImageView
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
    
    // MARK: - TextAreaScrollView
    fileprivate var textAreaScrollView = UIScrollView()
    fileprivate var textAreaHeight: CGFloat = 0.0
    
    // MARK: - TextAreaView
    fileprivate var textAreaView: UIView = UIView()
    
    // MARK: - TextContainer
    fileprivate var textContainer = UIView()
    fileprivate var textContainerHeightConstraint: NSLayoutConstraint!
    
    // MARK: - TitleLabel
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
    
    // MARK: - MessageView
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
    
    // MARK: - ButtonAreaScrollView
    fileprivate var buttonAreaScrollView = UIScrollView()
    fileprivate var buttonAreaScrollViewHeightConstraint: NSLayoutConstraint!
    fileprivate var buttonAreaHeight: CGFloat = 0.0
    
    // MARK: - ButtonAreaView
    fileprivate var buttonAreaView = UIView()
    
    // MARK: - ButtonContainer
    fileprivate var buttonContainer = UIView()
    fileprivate var buttonContainerHeightConstraint: NSLayoutConstraint!
    fileprivate var buttonHeight: CGFloat {
        get {
            return self.diffIcon ? 40.0 : 44.0
        }
    }
    fileprivate var buttonMargin: CGFloat = 8.0
    
    // MARK: - Shared
    // Shared Only one cancel button
    fileprivate var buttonStyle: AlertItemStyle?
    
    // Shared
    lazy fileprivate var sharedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.setTitleColor(self.theme.buttonTitleColor, for: .normal)
        guard let buttonStyle = self.buttonStyle else { return button }
        if case AlertItemStyle.cancel(let cancel) = buttonStyle {
            button.setTitle(cancel, for: .normal)
        }
        button.titleLabel?.font = self.theme.buttonTitleFont
        button.addTarget(self, action: .sharedCancelButtonTapped, for: .touchUpInside)
        button.addBorder(edges: [.top])
        return button
    }()
    
    // Shared collection view
    lazy fileprivate var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.isUserInteractionEnabled = true
        collectionView.register(AlertSharedItemCell.self, forCellWithReuseIdentifier: String(describing: AlertSharedItemCell.self))
        return collectionView
    }()
    
    fileprivate var sharedItems: [AlertSharedItem] = []
    
    // MARK: - Normal Buttons
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
                              cancelButton: AlertItemStyle?,
                              destructiveButton: AlertItemStyle?,
                              otherButtons: [AlertItemStyle],
                              tapClosure: AlertTapColsure?) {
        
        self.init(nibName: nil, bundle: nil)
        
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
        
        buttonStyles = otherButtons
        
        if let destructive = destructiveButton {
            buttonStyles.append(destructive)
        }
        if let cancel = cancelButton {
            buttonStyles.append(cancel)
        }
        buttons = addButtons(with: buttonStyles)
    }
    
    internal convenience init(with theme: AlertTheme,
                              preferredStyle: AlertViewStyle,
                              shares: [AlertSharedItem],
                              cancelButton: AlertItemStyle?,
                              tappedClosure: AlertTapColsure?) {
        
        self.init(nibName: nil, bundle: nil)
        self.isShared = true
        self.preferredStyle = preferredStyle
        self.theme = theme
        self.tappedButtonClosure = tappedClosure
        self.buttonStyle = cancelButton
        self.sharedItems = shares
        
        sizeConfigure()
        configureSubView()
    }
    
    override init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName:nibNameOrNil,
                   bundle:nibBundleOrNil)
        settings()
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
        if owner == nil { layoutSubView() }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Add Gesture if is not shared action sheet
        if !isShared {
            if (!isAlert() && cancelButtonTag != Int.baseTag) {
                let tap = UITapGestureRecognizer(target: self,
                                                 action: .handleContainerViewTapGesture)
                tap.delegate = self
                containerView.addGestureRecognizer(tap)
            }
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
            case .cancel(_): button.addTarget(self,
                                              action: .handleContainerViewTapGesture,
                                              for: .touchUpInside)
            default: button.addTarget(self,
                                      action: .alertActionButtonTapped,
                                      for: .touchUpInside)
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
        if owner != nil { return }
        
        if (layoutFlg) { return }
        layoutFlg = true
        alertView.backgroundColor = alertViewBackgroundColor
        circleView.backgroundColor = alertViewBackgroundColor
        if !isShared {
            setIcon()
            setTextContent()
            setButtonArea()
            //------------------------------
            // AlertView Layout
            //------------------------------
            // AlertView Height
            reloadAlertViewHeight()
            alertView.frame.size = CGSize(width: alertViewWidth,
                                          height: alertViewHeightConstraint.constant + textAreaHeightPadding)
        } else {
            let itemsCount = (self.sharedItems.count - 1) / .sharedItemOnOneColumn + 1
            alertViewHeightConstraint.constant = 44 + actionSheetBounceHeight + CGFloat(itemsCount * 64)
            alertView.frame.size = CGSize(width: alertViewWidth,
                                          height: alertViewHeightConstraint.constant + actionSheetBounceHeight)
        }
    }
    
    fileprivate func configure(item button: UIButton) {
        let style = buttonStyles[buttons.index(of: button) ?? 0]
        let backgroundColor = self.diffIcon ? self.getButtonBackgroundColor() : self.buttonBackgroundColor(with: style)
        
        button.titleLabel?.font = self.theme.buttonTitleFont
        button.titleLabel?.lineBreakMode = .byWordWrapping
        if diffIcon {
            button.setTitleColor(UIColor.white, for: .normal)
        }
        button.setBackgroundImage(createImage(with: backgroundColor),
                                  for: .normal)
        button.setBackgroundImage(createImage(with: backgroundColor),
                                  for: .highlighted)
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
            iconBackgroundView.frame = CGRect(x: 0,
                                              y: 0,
                                              width: CGFloat.iconBackgroundViewSize,
                                              height: CGFloat.iconBackgroundViewSize)
            iconBackgroundView.center = CGPoint(x: CGFloat.circleSize / 2.0,
                                                y: CGFloat.circleSize / 2.0)
            iconBackgroundView.layer.cornerRadius = CGFloat.iconBackgroundViewSize / 2.0
            circleView.addSubview(iconBackgroundView)
            
            // ICON FRAME
            iconImageView.frame = CGRect(x: 0,
                                         y: 0,
                                         width: CGFloat.iconSize,
                                         height: CGFloat.iconSize)
            iconImageView.center = CGPoint(x: CGFloat.iconBackgroundViewSize / 2.0,
                                           y: CGFloat.iconBackgroundViewSize / 2.0)
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
            titleLabel.frame = CGRect(x: innerContentWidthPadding,
                                      y: textAreaPositionY,
                                      width: innerContentWidth - 2 * innerContentWidthPadding,
                                      height: titleLabel.frame.height)
            textAreaPositionY += titleLabel.frame.height + 5.0
        }
        
        // MessageView
        if (hasMessage) {
            self.configureMessage()
            messageView.frame = CGRect(x: innerContentWidthPadding,
                                       y: textAreaPositionY,
                                       width: innerContentWidth - 2 * innerContentWidthPadding,
                                       height: messageView.frame.height)
            textAreaPositionY += messageView.frame.height + 5.0
        }
        
        if (!hasTitle && !hasMessage) {
            textAreaPositionY = 0.0
        }
        
        // TextAreaScrollView
        textAreaHeight = textAreaPositionY
        textAreaScrollView.contentSize = CGSize(width: alertViewWidth,
                                                height: textAreaHeight)
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
                button.frame = CGRect(x: buttonPositionX,
                                      y: buttonAreaPositionY,
                                      width: buttonWidth,
                                      height: buttonHeight)
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
                    button.frame = CGRect(x: padding,
                                          y: buttonAreaPositionY,
                                          width: width,
                                          height: self.resetButtonHeight(with: style.buttonTitle))
                    buttonAreaPositionY += self.resetButtonHeight(with: style.buttonTitle) + buttonMargin
                }
            }
            // Cancel Button
            if (!isAlert() && buttons.count > 1) {
                buttonAreaPositionY += buttonMargin
            }
            if cancelButtonTag != 0 {
                let button = buttonAreaScrollView.viewWithTag(cancelButtonTag) as! UIButton
                self.configure(item: button)
                button.frame = CGRect(x: padding,
                                      y: buttonAreaPositionY,
                                      width: width,
                                      height: cancelHeight)
            }
            buttonAreaPositionY += cancelHeight
        }
        buttonAreaPositionY += alertViewPadding
        if (buttons.count == 0) { buttonAreaPositionY = 0.0 }
        // ButtonAreaScrollView Height
        buttonAreaHeight = buttonAreaPositionY
        buttonAreaScrollView.contentSize = CGSize(width: alertViewWidth,
                                                  height: buttonAreaHeight)
        buttonContainerHeightConstraint.constant = buttonAreaHeight
    }
    
    fileprivate func configureTitle() {
        titleLabel.frame.size    = CGSize(width: innerContentWidth - 2 * innerContentWidthPadding,
                                          height: 0.0)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font          = titleFont
        titleLabel.textColor     = titleTextColor
        titleLabel.text          = title
        titleLabel.sizeToFit()
        textContainer.addSubview(titleLabel)
    }
    
    fileprivate func configureMessage() {
        messageView.frame.size    = CGSize(width: innerContentWidth - 2 * innerContentWidthPadding,
                                           height: 0.0)
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
            
            result = title.height(width,
                                  font: self.theme.buttonTitleFont,
                                  lineBreakMode: .byWordWrapping) + offset
        }
        return result
    }
    
    private func addSubviews() {
        // AlertView
        containerView.addSubview(alertView)
        
        if isShared {
            alertView.addSubview(sharedButton)
            alertView.addSubview(collectionView)
        } else {
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
        sharedButton.translatesAutoresizingMaskIntoConstraints         = false
        collectionView.translatesAutoresizingMaskIntoConstraints       = false
    }
    
    private func alertConstraint() {
        // ContainerView
        let alertViewCenterXConstraint = NSLayoutConstraint(item: alertView,
                                                            attribute: .centerX,
                                                            relatedBy: .equal,
                                                            toItem: containerView,
                                                            attribute: .centerX,
                                                            multiplier: 1.0,
                                                            constant: 0.0)
        let alertViewCenterYConstraint = NSLayoutConstraint(item: alertView,
                                                            attribute: .centerY,
                                                            relatedBy: .equal,
                                                            toItem: containerView,
                                                            attribute: .centerY,
                                                            multiplier: 1.0,
                                                            constant: 0.0)
        containerView.addConstraints([alertViewCenterXConstraint, alertViewCenterYConstraint])
        
        // AlertView
        let alertViewWidthConstraint = NSLayoutConstraint(item: alertView,
                                                          attribute: .width,
                                                          relatedBy: .equal,
                                                          toItem: nil,
                                                          attribute: .width,
                                                          multiplier: 1.0,
                                                          constant:
            alertViewWidth)
        alertViewHeightConstraint = NSLayoutConstraint(item: alertView,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: nil,
                                                       attribute: .height,
                                                       multiplier: 1.0,
                                                       constant: 1000.0)
        alertView.addConstraints([
            alertViewWidthConstraint,
            alertViewHeightConstraint])
        
        if self.diffIcon {
            let circleViewTopSpaceConstraint = NSLayoutConstraint(item: circleView,
                                                                  attribute: .top,
                                                                  relatedBy: .equal,
                                                                  toItem: alertView,
                                                                  attribute: .top,
                                                                  multiplier: 1.0,
                                                                  constant: -CGFloat.circleSize / 2.0)
            let circleViewCenterXConstraint = NSLayoutConstraint(item: circleView,
                                                                 attribute: .centerX,
                                                                 relatedBy: .equal,
                                                                 toItem: alertView,
                                                                 attribute: .centerX,
                                                                 multiplier: 1.0,
                                                                 constant: 0.0)
            alertView.addConstraints([
                circleViewTopSpaceConstraint,
                circleViewCenterXConstraint])
            
            // Circle View
            let circleViewHeightConstraint = NSLayoutConstraint(item: circleView,
                                                                attribute: .height,
                                                                relatedBy: .equal,
                                                                toItem: nil,
                                                                attribute: .height,
                                                                multiplier: 1.0,
                                                                constant: CGFloat.circleSize)
            let circleViewWidthConstraint = NSLayoutConstraint(item: circleView,
                                                               attribute: .width,
                                                               relatedBy: .equal,
                                                               toItem: nil,
                                                               attribute: .width,
                                                               multiplier: 1.0,
                                                               constant: CGFloat.circleSize)
            circleView.addConstraints([
                circleViewWidthConstraint,
                circleViewHeightConstraint])
        }
    }
    
    private func actionSheetConstrtaint() {
        // ContainerView
        let alertViewCenterXConstraint = NSLayoutConstraint(item: alertView,
                                                            attribute: .centerX,
                                                            relatedBy: .equal,
                                                            toItem: containerView,
                                                            attribute: .centerX,
                                                            multiplier: 1.0,
                                                            constant: 0.0)
        let alertViewBottomSpaceConstraint = NSLayoutConstraint(item: alertView,
                                                                attribute: .bottom,
                                                                relatedBy: .equal,
                                                                toItem: containerView,
                                                                attribute: .bottom,
                                                                multiplier: 1.0,
                                                                constant: actionSheetBounceHeight)
        let alertViewWidthConstraint = NSLayoutConstraint(item: alertView,
                                                          attribute: .width,
                                                          relatedBy: .equal,
                                                          toItem: containerView,
                                                          attribute: .width,
                                                          multiplier: 1.0,
                                                          constant: 0.0)
        containerView.addConstraints([
            alertViewCenterXConstraint,
            alertViewBottomSpaceConstraint,
            alertViewWidthConstraint])
        
        // AlertView
        alertViewHeightConstraint = NSLayoutConstraint(item: alertView,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: nil,
                                                       attribute: .height,
                                                       multiplier: 1.0,
                                                       constant: 1000.0)
        alertView.addConstraint(alertViewHeightConstraint)
    }
    
    // MARK: - AlertView Constraint
    private func alertViewConstraint() {
        let textAreaScrollViewTopSpaceConstraint = NSLayoutConstraint(item: textAreaScrollView,
                                                                      attribute: .top,
                                                                      relatedBy: .equal,
                                                                      toItem: self.diffIcon ? circleView : alertView,
                                                                      attribute: self.diffIcon ? .bottom : .top,
                                                                      multiplier: 1.0,
                                                                      constant: self.hasIconTopPadding)
        let textAreaScrollViewRightSpaceConstraint = NSLayoutConstraint(item: textAreaScrollView,
                                                                        attribute: .right,
                                                                        relatedBy: .equal,
                                                                        toItem: alertView,
                                                                        attribute: .right,
                                                                        multiplier: 1.0,
                                                                        constant: 0.0)
        let textAreaScrollViewLeftSpaceConstraint = NSLayoutConstraint(item: textAreaScrollView,
                                                                       attribute: .left,
                                                                       relatedBy: .equal,
                                                                       toItem: alertView,
                                                                       attribute: .left,
                                                                       multiplier: 1.0,
                                                                       constant: 0.0)
        let textAreaScrollViewBottomSpaceConstraint = NSLayoutConstraint(item: textAreaScrollView,
                                                                         attribute: .bottom,
                                                                         relatedBy: .equal,
                                                                         toItem: buttonAreaScrollView,
                                                                         attribute: .top,
                                                                         multiplier: 1.0,
                                                                         constant: self.textAreaPadding)
        
        let buttonAreaScrollViewRightSpaceConstraint = NSLayoutConstraint(item: buttonAreaScrollView,
                                                                          attribute: .right,
                                                                          relatedBy: .equal,
                                                                          toItem: alertView,
                                                                          attribute: .right,
                                                                          multiplier: 1.0,
                                                                          constant: 0.0)
        let buttonAreaScrollViewLeftSpaceConstraint = NSLayoutConstraint(item: buttonAreaScrollView,
                                                                         attribute: .left,
                                                                         relatedBy: .equal,
                                                                         toItem: alertView,
                                                                         attribute: .left,
                                                                         multiplier: 1.0,
                                                                         constant: 0.0)
        let buttonAreaScrollViewBottomSpaceConstraint = NSLayoutConstraint(item: buttonAreaScrollView,
                                                                           attribute: .bottom,
                                                                           relatedBy: .equal,
                                                                           toItem: alertView,
                                                                           attribute: .bottom,
                                                                           multiplier: 1.0,
                                                                           constant: isAlert() ? 0.0 : -actionSheetBounceHeight)
        alertView.addConstraints([
            textAreaScrollViewTopSpaceConstraint,
            textAreaScrollViewLeftSpaceConstraint,
            textAreaScrollViewRightSpaceConstraint,
            textAreaScrollViewBottomSpaceConstraint,
            buttonAreaScrollViewRightSpaceConstraint,
            buttonAreaScrollViewLeftSpaceConstraint,
            buttonAreaScrollViewBottomSpaceConstraint])
    }
    
    private func sharedConstraint() {
        let cancelButtonRightSpaceConstraint = NSLayoutConstraint(item: sharedButton, attribute: .right, relatedBy: .equal, toItem: alertView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let cancelButtonLeftSpaceConstraint = NSLayoutConstraint(item: sharedButton, attribute: .left, relatedBy: .equal, toItem: alertView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let cancelButtonBottomSpaceConstraint = NSLayoutConstraint(item: sharedButton, attribute: .bottom, relatedBy: .equal, toItem: alertView, attribute: .bottom, multiplier: 1.0, constant: -actionSheetBounceHeight)
        
        let collectionViewTopSpaceConstraint = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: alertView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let collectionViewLeftSpaceConstraint = NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: alertView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let collectionViewRightSpaceConstraint = NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: alertView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let collectionViewBottomToCancelConstraint = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: sharedButton, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        alertView.addConstraints([
                cancelButtonRightSpaceConstraint,
                cancelButtonLeftSpaceConstraint,
                cancelButtonBottomSpaceConstraint,
                collectionViewTopSpaceConstraint,
                collectionViewLeftSpaceConstraint,
                collectionViewRightSpaceConstraint,
                collectionViewBottomToCancelConstraint
            ])
        
        let sharedHeightConstraint = NSLayoutConstraint(item: sharedButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 44)
        sharedButton.addConstraint(sharedHeightConstraint)
    }
    
    // MARK: - TextAreaScrollView Constraint
    private func textAreaConstraint() {
        let textAreaViewTopSpaceConstraint = NSLayoutConstraint(item: textAreaView,
                                                                attribute: .top,
                                                                relatedBy: .equal,
                                                                toItem: textAreaScrollView,
                                                                attribute: .top,
                                                                multiplier: 1.0,
                                                                constant: 0.0)
        let textAreaViewRightSpaceConstraint = NSLayoutConstraint(item: textAreaView,
                                                                  attribute: .right,
                                                                  relatedBy: .equal,
                                                                  toItem: textAreaScrollView,
                                                                  attribute: .right,
                                                                  multiplier: 1.0,
                                                                  constant: 0.0)
        let textAreaViewLeftSpaceConstraint = NSLayoutConstraint(item: textAreaView,
                                                                 attribute: .left,
                                                                 relatedBy: .equal,
                                                                 toItem: textAreaScrollView,
                                                                 attribute: .left,
                                                                 multiplier: 1.0,
                                                                 constant: 0.0)
        let textAreaViewBottomSpaceConstraint = NSLayoutConstraint(item: textAreaView,
                                                                   attribute: .bottom,
                                                                   relatedBy: .equal,
                                                                   toItem: textAreaScrollView,
                                                                   attribute: .bottom,
                                                                   multiplier: 1.0,
                                                                   constant: 0.0)
        textAreaScrollView.addConstraints([
            textAreaViewTopSpaceConstraint,
            textAreaViewRightSpaceConstraint,
            textAreaViewLeftSpaceConstraint,
            textAreaViewBottomSpaceConstraint])
        
        // TextArea Constraint
        let textAreaViewHeightConstraint = NSLayoutConstraint(item: textAreaView,
                                                              attribute: .height,
                                                              relatedBy: .equal,
                                                              toItem: textContainer,
                                                              attribute: .height,
                                                              multiplier: 1.0,
                                                              constant: 0.0)
        let textContainerTopSpaceConstraint = NSLayoutConstraint(item: textContainer,
                                                                 attribute: .top,
                                                                 relatedBy: .equal,
                                                                 toItem: textAreaView,
                                                                 attribute: .top,
                                                                 multiplier: 1.0,
                                                                 constant: 0.0)
        let textContainerLeftSpaceConstraint = NSLayoutConstraint(item: textContainer,
                                                                  attribute: .left,
                                                                  relatedBy: .equal,
                                                                  toItem: textAreaView,
                                                                  attribute: .left,
                                                                  multiplier: 1.0,
                                                                  constant: 0.0)
        textAreaView.addConstraints([textAreaViewHeightConstraint, textContainerTopSpaceConstraint, textContainerLeftSpaceConstraint])
        
        // TextContainer Constraint
        let textContainerWidthConstraint = NSLayoutConstraint(item: textContainer,
                                                              attribute: .width,
                                                              relatedBy: .equal,
                                                              toItem: nil,
                                                              attribute: .width,
                                                              multiplier: 1.0,
                                                              constant: alertViewWidth)
        textContainerHeightConstraint = NSLayoutConstraint(item: textContainer,
                                                           attribute: .height,
                                                           relatedBy: .equal,
                                                           toItem: nil,
                                                           attribute: .height,
                                                           multiplier: 1.0,
                                                           constant: 0.0)
        textContainer.addConstraints([textContainerWidthConstraint, textContainerHeightConstraint])
    }
    
    // MARK: - ButtonAreaScrollView Constraint
    private func buttonAreaConstraint() {
        buttonAreaScrollViewHeightConstraint = NSLayoutConstraint(item: buttonAreaScrollView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.0)
        let buttonAreaViewTopSpaceConstraint = NSLayoutConstraint(item: buttonAreaView, attribute: .top, relatedBy: .equal, toItem: buttonAreaScrollView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let buttonAreaViewLeftSpaceConstraint = NSLayoutConstraint(item: buttonAreaView, attribute: .left, relatedBy: .equal, toItem: buttonAreaScrollView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let buttonAreaViewWidthConstraint = NSLayoutConstraint(item: buttonAreaView, attribute: .width, relatedBy: .equal, toItem: buttonAreaScrollView, attribute: .width, multiplier: 1.0, constant: 0.0)
        let buttonAreaViewHeightConstraint = NSLayoutConstraint(item: buttonAreaView, attribute: .height, relatedBy: .equal, toItem: buttonAreaScrollView, attribute: .height, multiplier: 1.0, constant: 0.0)
        buttonAreaScrollView.addConstraints([buttonAreaScrollViewHeightConstraint, buttonAreaViewTopSpaceConstraint, buttonAreaViewLeftSpaceConstraint, buttonAreaViewWidthConstraint, buttonAreaViewHeightConstraint])
        
        // ButtonArea Constraint
        let buttonContainerTopSpaceConstraint = NSLayoutConstraint(item: buttonContainer, attribute: .top, relatedBy: .equal, toItem: buttonAreaView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let buttonContainerCenterXConstraint = NSLayoutConstraint(item: buttonContainer, attribute: .centerX, relatedBy: .equal, toItem: buttonAreaView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        buttonAreaView.addConstraints([buttonContainerTopSpaceConstraint, buttonContainerCenterXConstraint])
        
        // ButtonContainer Constraint
        let buttonContainerWidthConstraint = NSLayoutConstraint(item: buttonContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: self.isAlert() ? innerButtonWidth : innerContentWidth)
        buttonContainerHeightConstraint = NSLayoutConstraint(item: buttonContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: buttonHeight)
        buttonContainer.addConstraints([buttonContainerWidthConstraint, buttonContainerHeightConstraint])
    }
    
    /**
     Show subviews at alertView
     
     - author: Shi Wei
     - date: 16-07-31 12:07:51
     */
    // MARK: - ContainerView && AlertView Constraint
    fileprivate func configureSubView() {
        layoutBackgroundView()
        addSubviews()
        translaterAutoresizingMaskIntoConstraints()
        
        if (isAlert()) {
            alertConstraint()
        } else {
            actionSheetConstrtaint()
        }
        if !isShared {
            alertViewConstraint()
            textAreaConstraint()
            buttonAreaConstraint()
        } else {
            sharedConstraint()
        }
    }
    
    fileprivate func layoutBackgroundView() {
        
        var constraints: [NSLayoutConstraint] = []
        
        if case AlertOverlay.normal(_) = self.theme.overlay {
            self.view.addSubview(overlayView)
            overlayView.translatesAutoresizingMaskIntoConstraints = false
            //------------------------------
            // Layout & Color Settings
            //------------------------------
            overlayView.backgroundColor = overlayColor
            
            let overlayViewTopSpaceConstraint = NSLayoutConstraint(item: overlayView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
            let overlayViewRightSpaceConstraint = NSLayoutConstraint(item: overlayView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0)
            let overlayViewLeftSpaceConstraint = NSLayoutConstraint(item: overlayView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0)
            let overlayViewBottomSpaceConstraint = NSLayoutConstraint(item: overlayView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            constraints = [
                overlayViewTopSpaceConstraint,
                overlayViewRightSpaceConstraint,
                overlayViewLeftSpaceConstraint,
                overlayViewBottomSpaceConstraint
            ]
        } else {
            if let blurEffectView = blurEffectView {
                self.view.addSubview(blurEffectView)
            }
        }
        
        // ContainerView
        self.view.addSubview(containerView)
        
        //------------------------------
        // Layout Constraint
        //------------------------------
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // self.view
        
        let containerViewTopSpaceConstraint = NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let containerViewRightSpaceConstraint = NSLayoutConstraint(item: containerView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0)
        let containerViewLeftSpaceConstraint = NSLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0)
        containerViewBottomSpaceConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        constraints.append(contentsOf: [
                containerViewTopSpaceConstraint,
                containerViewRightSpaceConstraint,
                containerViewLeftSpaceConstraint,
                containerViewBottomSpaceConstraint
            ])
        self.view.addConstraints(constraints)
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
    @objc func buttonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if let c = self.tappedButtonClosure {
            c(sender.tag - Int.baseTag)
        }
    }
    
    @objc fileprivate func sharedCancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Handle ContainerView tap gesture
    @objc func handleContainerViewTapGesture(_ sender: AnyObject) {
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
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIButton)
    }
    
}

extension AlertView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: nil)
        if let closure = self.tappedButtonClosure {
            closure(indexPath.row)
        }
    }
}

extension AlertView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AlertSharedItemCell.self), for: indexPath) as! AlertSharedItemCell
        itemCell.bindAlertSharedItem(self.sharedItems[indexPath.row])
        let edges: UIRectEdge = (indexPath.row + 1) % 3 == 0 ? [] : [.right]
        itemCell.addBorder(edges: edges)
        return itemCell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sharedItems.count
    }
}

extension AlertView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = self.sharedItems.count
        let separator = count <= .sharedItemOnOneColumn ? count : .sharedItemOnOneColumn
        let width = CGSize.screenSize.width / CGFloat(separator)
        let newWidth = width.rounded(.towardZero)
        return CGSize(width: newWidth, height: 64.0)

    }
}
