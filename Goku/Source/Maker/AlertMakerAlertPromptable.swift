//  AlertMakerAlertPromptable.swift
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

public struct AlertSharedItem {
    let platform: String
    let platformImage: String
    
    public init(platform: String, platformImage: String) {
        self.platform = platform
        self.platformImage = platformImage
    }
}

public class AlertMakerAlertPromptable: AlertMakerEditable  {
    
    internal func prompt(of prompt: AlertPrompt, content: String?, file: String, line: UInt) -> AlertMakerAlertPromptable {
        self.description.prompt = prompt
        if prompt.isTitlePrompt() {
            self.description.title = content
        } else {
            self.description.message = content
        }
        return self
    }
    
    @discardableResult
    public func title(_ title: String?, _ file: String = #file, _ line: UInt = #line) -> AlertMakerAlertPromptable {
        return self.prompt(of: .title, content: title, file: file, line: line)
    }
    
    @discardableResult
    public func message(_ message: String?, _ file: String = #file, _ line: UInt = #line) -> AlertMakerAlertPromptable {
        return self.prompt(of: .message, content: message, file: file, line: line)
    }
    
}
