//  AlertStyle.swift
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

import UIKit

public enum AlertStyle {
    case normal, success, failure, warning, notice, question
    
    func icon() -> UIImage? {
        switch self {
        case .success: return AlertViewStyleKit.checkmark.withRenderingMode(.alwaysTemplate)
        case .failure: return AlertViewStyleKit.cross.withRenderingMode(.alwaysTemplate)
        case .warning: return AlertViewStyleKit.warning.withRenderingMode(.alwaysTemplate)
        case .notice: return AlertViewStyleKit.notice.withRenderingMode(.alwaysTemplate)
        case .question: return AlertViewStyleKit.question.withRenderingMode(.alwaysTemplate)
        default: return nil
        }
    }
    
    func tintColor() -> UIColor? {
        switch self {
        case .success: return UIColor(hex: 0x22B573)
        case .failure: return UIColor(hex: 0xC1272D)
        case .warning: return UIColor(hex: 0xFF9A2F)
        case .notice: return UIColor(hex: 0x727375)
        case .question: return UIColor(hex: 0x727375)
        default: return nil
        }
    }
}
