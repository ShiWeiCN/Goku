//  AlertMaker.swift
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

public class AlertMaker {
    
    public var theme: AlertMakerExtendable { /// Default theme
        return self.makeExtendable(with: .theme)
    }
    
    public var alert: AlertMakerExtendable {
        return self.makeExtendable(with: .alert)
    }
    
    public var actionSheet: AlertMakerExtendable {
        return self.makeExtendable(with: .actionSheet)
    }
    
    public var customize: AlertMakerExtendable { /// Custom theme
        return self.makeExtendable(with: .customize)
    }
    
    private let item: AlertTargetItem
    private var description: AlertDescription? = nil
    
    internal init(item: AlertTargetItem) {
        self.item = item
    }
    
    internal func makeExtendable(with attributes: AlertAttributes) -> AlertMakerExtendable {
        let description = AlertDescription(item: self.item, attributes: attributes)
        self.description = description
        return AlertMakerExtendable(description)
    }
    
    internal static func presentAlert(item: AlertTargetItem, animated: Bool, closure: (_ make: AlertMaker) -> Void) -> AlertView {
        let maker = AlertMaker(item: item)
        closure(maker)
        guard maker.description != nil else {
            fatalError("Maker closure found nil!!!")
        }
        let description = maker.description!
        
        if !description.attributes.boolValue {
            fatalError("Alert view do not have any attributes")
        }
        
        return self.assembleAlertView(with: description)
    }
    
    fileprivate static let defaultActionSheet: UInt = AlertAttributes.actionSheet.toRaw() + AlertAttributes.theme.toRaw()
    fileprivate static let customActionSheet: UInt = AlertAttributes.actionSheet.toRaw() + AlertAttributes.customize.toRaw()
    
    fileprivate static let defaultAlert: UInt = AlertAttributes.alert.toRaw() + AlertAttributes.theme.toRaw()
    fileprivate static let customAlert: UInt = AlertAttributes.alert.toRaw() + AlertAttributes.customize.toRaw()
    
    fileprivate static func assembleAlertView(with description: AlertDescription) -> AlertView {
        // Style
        var style: AlertViewStyle
        let rawValue = description.attributes.toRaw()
        if rawValue == defaultActionSheet || rawValue == customActionSheet {
            style = .actionSheet
        } else if rawValue == defaultAlert || rawValue == customAlert {
            style = .alert(category: .normal)
        } else {
            style = self.alertStyle(by: rawValue)
        }
        let others: [AlertItemStyle] = description.normal.map { .other($0) }
        return AlertView(with: description.theme,
                         preferredStyle: style,
                         title: description.title,
                         message: description.message,
                         cancelButton: description.cancel == nil ? nil : .cancel(description.cancel!),
                         destructiveButton: description.destructive == nil ? nil : .destructive(description.destructive!),
                         otherButtons: others,
                         tapClosure: description.closure)
    }
    
    fileprivate static func alertStyle(by rawValue: UInt) -> AlertViewStyle {
        
        let rawValue1: AlertAttributes = AlertAttributes.fromMask(rawValue - defaultAlert)
        let rawValue2: AlertAttributes = AlertAttributes.fromMask(rawValue - customAlert)
        
        if rawValue1 == .success || rawValue2 == .success {
            return .alert(category: .success)
        } else if rawValue1 == .failure || rawValue2 == .failure {
            return .alert(category: .failure)
        } else if rawValue1 == .warning || rawValue2 == .warning {
            return .alert(category: .warning)
        } else if rawValue1 == .notice || rawValue2 == .notice {
            return .alert(category: .notice)
        } else if rawValue1 == .question || rawValue2 == .question {
            return .alert(category: .question)
        } else {
            return .alert(category: .normal)
        }
        
    }
    
}
