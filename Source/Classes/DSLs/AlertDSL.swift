//  AlertDSL.swift
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

protocol AlertDSL {
    
    var target: AnyObject? { get }
    
    func setLabel(_ value: String?)
    func label() -> String?
}

extension AlertDSL {
    func setLabel(_ value: String?) {
        objc_setAssociatedObject(self.target as Any, &labelKey, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    func label() -> String? {
        return objc_getAssociatedObject(self.target, &labelKey) as? String
    }
}

var labelKey: UInt8 = 0

protocol AlertBasicAttributesDSL: AlertDSL { }

extension AlertBasicAttributesDSL {
    
    /// Default theme
    var theme: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.theme)
    }
    
    /// Custom theme
    var customize: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.customize)
    }
    
    var actionSheet: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.actionSheet)
    }
    
    var alert: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.alert)
    }
    
    var success: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.success)
    }
    
    var failure: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.failure)
    }
    
    var warning: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.warning)
    }
    
    var notice: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.notice)
    }
    
    var question: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.question)
    }
    
}
