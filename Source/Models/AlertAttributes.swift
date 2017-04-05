//  AlertAttributes.swift
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

internal struct AlertAttributes: OptionSet {
    
    internal init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    internal init(_ rawValue: UInt) {
        self.init(rawValue: rawValue)
    }
    internal init(nilLiteral: ()) {
        self.rawValue = 0
    }
    
    internal private(set) var rawValue: UInt
    internal static var allZeros: AlertAttributes { return self.init(0) }
    internal static func convertFromNilLiteral() -> AlertAttributes { return self.init(0) }
    internal var boolValue: Bool { return self.rawValue != 0 }
    
    internal func toRaw() -> UInt { return self.rawValue }
    internal static func fromRaw(_ raw: UInt) -> AlertAttributes? { return self.init(raw) }
    internal static func fromMask(_ raw: UInt) -> AlertAttributes { return self.init(raw) }
    
    // normal
    internal static var theme: AlertAttributes { return self.init(2) } /// Default theme
    internal static var customize: AlertAttributes { return self.init(4) } /// Custom theme
    internal static var alert: AlertAttributes { return self.init(8) }
    internal static var actionSheet: AlertAttributes { return self.init(16) }
    
    // MARK: - Alert Style
    // Alert style list: normal, success, failure, warning, notice, question
    internal static var success: AlertAttributes { return self.init(32) }
    internal static var failure: AlertAttributes { return self.init(64) }
    internal static var warning: AlertAttributes { return self.init(128) }
    internal static var notice: AlertAttributes { return self.init(256) }
    internal static var question: AlertAttributes { return self.init(512) }
    
    // Custom Alert View Content
    internal static var owner: AlertAttributes { return self.init(1024) }
    
}

internal func + (left: AlertAttributes, right: AlertAttributes) -> AlertAttributes {
    return left.union(right)
}

internal func +=(left: inout AlertAttributes, right: AlertAttributes) {
    left.formUnion(right)
}

internal func -=(left: inout AlertAttributes, right: AlertAttributes) {
    left.subtract(right)
}

internal func ==(left: AlertAttributes, right: AlertAttributes) -> Bool {
    return left.rawValue == right.rawValue
}
