//  AlertDescription.swift
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

internal class AlertDescription {
    
    internal typealias Closure = (_ index: Int) -> Void
    
    internal var item: AlertTargetItem?
    internal var label: String? = nil
    internal var attributes: AlertAttributes
    internal var prompt: AlertPrompt? = nil
    internal var title: String? = nil
    internal var message: String? = nil
    internal var cancel: String? = nil
    internal var destructive: String? = nil
    internal var normal: [String] = [String]()
    internal var closure: Closure? = nil
    internal var theme: AlertTheme = AlertTheme.theme
    internal var shares: [AlertSharedItem] = [AlertSharedItem]()
    
    // MARK: Initialization
    
    internal init(item: AlertTargetItem, attributes: AlertAttributes) {
        self.attributes = attributes
        self.item = item
    }
    
}
