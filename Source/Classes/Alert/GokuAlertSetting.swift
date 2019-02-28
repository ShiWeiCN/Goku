//
//  GokuAlertSetting.swift
//  Goku
//
//  Created by shiwei on 2019/2/15.
//

import UIKit

public protocol GokuAlertSetting {
    var style: Goku.AlertStyle { get }
    var animation: GokuAlertAnimation { get }
    var theme: GokuAlertTheme { get }
}

public protocol GokuAlertAnimation {
    var presentAnimationDuration: TimeInterval { get }
    var dismissAnimationDuration: TimeInterval { get }
}

extension GokuAlertAnimation {
    public var presentAnimationDuration: TimeInterval {
        return 0.375
    }
    
    public var dismissAnimationDuration: TimeInterval {
        return 0.275
    }
}

public protocol GokuAlertTheme {
    var blurEffectStyle: UIBlurEffect.Style { get }
    
}

extension GokuAlertTheme {
    public var blurEffectStyle: UIBlurEffect.Style {
        return .dark
    }
}

public struct Goku {
    public enum AlertStyle {
        case alert
        case actionSheet
    }
    
    public struct Setting: GokuAlertSetting {
        public let style: Goku.AlertStyle
        
        public var animation: GokuAlertAnimation {
            return Animation.default
        }
        
        public var theme: GokuAlertTheme {
            return Theme.default
        }
        
        public init(style: Goku.AlertStyle) {
            self.style = style
        }
        
        public static let alert: Setting = Setting(style: .alert)
        public static let actionSheet: Setting = Setting(style: .actionSheet)
    }
    
    public struct Theme: GokuAlertTheme {
        public static let `default` = Theme()
    }
    
    public struct Animation: GokuAlertAnimation {
        public static let `default` = Animation()
    }
}
