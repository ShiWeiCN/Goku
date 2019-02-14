//  AlertDSL.swift
//  Goku (https://github.com/shiwei93/Goku)
//
//
//  Copyright (c) 2017 shiwei (https://szewei.me/)
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

internal protocol AlertDSL {
    
    var target: AnyObject? { get }
    
    func setLabel(_ value: String?)
    func label() -> String?
}

internal extension AlertDSL {
    internal func setLabel(_ value: String?) {
        objc_setAssociatedObject(self.target as Any, &labelKey, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    internal func label() -> String? {
        return objc_getAssociatedObject(self.target, &labelKey) as? String
    }
}

internal var labelKey: UInt8 = 0

internal protocol AlertBasicAttributesDSL: AlertDSL { }

internal extension AlertBasicAttributesDSL {
    
    /// Default theme
    internal var theme: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.theme)
    }
    
    /// Custom theme
    internal var customize: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.customize)
    }
    
    internal var actionSheet: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.actionSheet)
    }
    
    internal var alert: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.alert)
    }
    
    internal var success: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.success)
    }
    
    internal var failure: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.failure)
    }
    
    internal var warning: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.warning)
    }
    
    internal var notice: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.notice)
    }
    
    internal var question: AlertItem {
        return AlertItem(target: self.target, attributes: AlertAttributes.question)
    }
    
}
