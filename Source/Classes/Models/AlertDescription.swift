//  AlertDescription.swift
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

import UIKit

class AlertDescription {
    
    typealias Closure = (_ index: Int) -> Void
    
    var item: AlertTargetItem?
    var label: String? = nil
    var attributes: AlertAttributes
    var prompt: AlertPrompt? = nil
    var title: String? = nil
    var message: String? = nil
    var cancel: String? = nil
    var destructive: String? = nil
    var normal: [String] = [String]()
    var closure: Closure? = nil
    var theme: AlertTheme = AlertTheme.theme
    var shares: [AlertSharedItem] = [AlertSharedItem]()
    
    // MARK: Initialization
    init(item: AlertTargetItem, attributes: AlertAttributes) {
        self.attributes = attributes
        self.item = item
    }
    
}
