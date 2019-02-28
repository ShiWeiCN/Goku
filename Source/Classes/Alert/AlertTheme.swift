//  AlertTheme.swift
//  Goku (https://github.com/shiwei93/Goku)
//
//
//  Copyright (c) 2019 shiwei93 (https://szewei.me/)
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

public typealias CornerRadius = CGFloat

// Alert view & Action Sheet Background view's shape
public enum AlertShape {
    
    case squared
    case rounded(CornerRadius)
    
    var cornerRadius: CornerRadius {
        get {
            switch self {
                case .squared: return 0.0
                case .rounded(let cornerRadius): return cornerRadius
            }
        }
    }
}

public enum AlertOverlay {
    
    case normal(UIColor)
    case blurEffect(UIBlurEffect.Style)
    
}

public class AlertTheme {
    
    //
    public typealias Font = UIFont
    public typealias Color = UIColor
    
    // MARK: Private
    
    fileprivate(set) var overlay: AlertOverlay
    fileprivate(set) var backgroundColor: Color
    
    fileprivate(set) var titleFont: Font
    fileprivate(set) var titleColor: Color
    fileprivate(set) var messageFont: Font
    fileprivate(set) var messageColor: Color

    fileprivate(set) var buttonTitleFont: Font
    fileprivate(set) var buttonTitleColor: Color
    fileprivate(set) var buttonBackgroundColor: Color
    
    fileprivate(set) var cancelButtonBackgroundColor: Color
    fileprivate(set) var cancelButtonTitleColor: Color
    
    fileprivate(set) var destructBackgroundColor: Color
    fileprivate(set) var destructTitleColor: Color
    
    fileprivate(set) var shape: AlertShape
    
    // MARK: Public
    
    public class var theme: AlertTheme {
        get {
            return AlertTheme(overlay: .blurEffect(.dark),
                              backgroundColor: Color.backgroundColor,
                              titleFont: Font.boldSystemFont(ofSize: 18),
                              titleColor: Color.textColor,
                              messageFont: Font.systemFont(ofSize: 16),
                              messageColor: Color.textColor,
                              buttonTitleFont: Font.boldSystemFont(ofSize: 16),
                              buttonTitleColor: Color.black.withAlphaComponent(0.85),
                              buttonBackgroundColor: Color.otherColor,
                              cancelButtonBackgroundColor: Color.cancelColor,
                              cancelButtonTitleColor: Color.black,
                              destructBackgroundColor: Color.destructiveColor,
                              destructTitleColor: Color.white,
                              shape: AlertShape.rounded(2.0))
        }
    }
    
    // MARK: Initialization
    
    init(overlay: AlertOverlay,
                  backgroundColor: UIColor,
                  titleFont: Font,
                  titleColor: Color,
                  messageFont: Font,
                  messageColor: Color,
                  buttonTitleFont: Font,
                  buttonTitleColor: Color,
                  buttonBackgroundColor: Color,
                  cancelButtonBackgroundColor: Color,
                  cancelButtonTitleColor: Color,
                  destructBackgroundColor: Color,
                  destructTitleColor: Color,
                  shape: AlertShape) {
        
        self.overlay = overlay
        self.backgroundColor = backgroundColor
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.messageFont = messageFont
        self.messageColor = messageColor
        self.buttonTitleFont = buttonTitleFont
        self.buttonTitleColor = buttonTitleColor
        self.buttonBackgroundColor = buttonBackgroundColor
        self.cancelButtonBackgroundColor = cancelButtonBackgroundColor
        self.cancelButtonTitleColor = cancelButtonTitleColor
        self.destructBackgroundColor = destructBackgroundColor
        self.destructTitleColor = destructTitleColor
        self.shape = shape
    }
    
    public func overlay(_ overlay: AlertOverlay) -> AlertTheme {
        self.overlay = overlay
        return self
    }
    
    public func backgroundColor(_ background: UIColor) -> AlertTheme {
        self.backgroundColor = background
        return self
    }
    
    public func titleFont(_ font: Font) -> AlertTheme {
        self.titleFont = font
        return self
    }
    
    public func titleColor(_ color: Color) -> AlertTheme {
        self.titleColor = color
        return self
    }
    
    public func messageFont(_ font: Font) -> AlertTheme {
        self.messageFont = font
        return self
    }
    
    public func messageColor(_ color: Color) -> AlertTheme {
        self.messageColor = color
        return self
    }
    
    public func buttonTitleFont(_ font: Font) -> AlertTheme {
        self.buttonTitleFont = font
        return self
    }
    
    public func buttonTitleColor(_ color: Color) -> AlertTheme {
        self.buttonTitleColor = color
        return self
    }
    
    public func buttonBackgroundColor(_ color: Color) -> AlertTheme {
        self.buttonBackgroundColor = color
        return self
    }
    
    public func cancelBackgroundColor(_ color: Color) -> AlertTheme {
        self.cancelButtonBackgroundColor = color
        return self
    }
    
    public func cancelTitleColor(_ color: Color) -> AlertTheme {
        self.cancelButtonTitleColor = color
        return self
    }
    
    public func destructBackgroundColor(_ color: Color) -> AlertTheme {
        self.destructBackgroundColor = color
        return self
    }
    
    public func destructTitleColor(_ color: Color) -> AlertTheme {
        self.destructTitleColor = color
        return self
    }
    
    public func shape(_ shape: AlertShape) -> AlertTheme {
        self.shape = shape
        return self
    }
    
    func isBlurEffectView() -> Any {
        if case AlertOverlay.blurEffect(let style) = self.overlay {
            return style
        } else {
            return false
        }
    }
    
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    convenience init(hex: Int) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0, green: CGFloat((hex & 0xFF00) >> 8) / 255.0, blue: CGFloat(hex & 0xFF) / 255.0, alpha: 1.0)
    }
    
    class var backgroundColor: UIColor {
        get {
            return UIColor(r: 239, g: 240, b: 242)
        }
    }
    
    class var overlayColor: UIColor {
        get {
            return UIColor(r: 0, g: 0, b: 0, a: 0.5)
        }
    }
    
    class var textColor: UIColor {
        get {
            return UIColor(r: 77, g: 77, b: 77)
        }
    }
    
    class var destructiveColor: UIColor {
        get {
            return UIColor(r: 231, g: 76, b: 70)
        }
    }
    
    class var cancelColor: UIColor {
        get {
            return UIColor(r: 245, g: 245, b: 245, a: 1)
        }
    }
    
    class var otherColor: UIColor {
        get {
            return UIColor(r: 245, g: 245, b: 245)
        }
    }
}
