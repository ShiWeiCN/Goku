//  AlertMakerExtendable.swift
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

public class AlertMakerExtendable: AlertMakerAlertPromptable {
    
    public var theme: AlertMakerExtendable { /// Default theme
        return self.removeItem(ifExist: .customize, closure: { 
            self.description.attributes += .theme
        })
    }
    
    public var alert: AlertMakerExtendable {
        return self.removeItem(ifExist: .actionSheet, closure: {
            self.description.attributes += .alert
        })
    }
    
    public var actionSheet: AlertMakerExtendable {
        return self.removeItem(ifExist: .alert, closure: {
            self.description.attributes += .actionSheet
        })
    }
    
    public var customize: AlertMakerExtendable { /// Custom theme
        return self.removeItem(ifExist: .theme, closure: { 
            self.description.attributes += .customize
        })
    }
    
    public var success: AlertMakerExtendable { /// Alert success style
        return self.removeItem(ifExist: .actionSheet, closure: { 
            self.makeMoreStyleAlert(.success)
        })
    }
    
    public var failure: AlertMakerExtendable { /// Alert failure style
        return self.removeItem(ifExist: .actionSheet, closure: { 
            self.makeMoreStyleAlert(.failure)
        })
    }
    
    public var warning: AlertMakerExtendable { /// Alert warning style
        return self.removeItem(ifExist: .warning, closure: { 
            self.makeMoreStyleAlert(.warning)
        })
    }
    
    
    public var notice: AlertMakerExtendable { /// Alert notice style
        return self.removeItem(ifExist: .notice, closure: { 
            self.makeMoreStyleAlert(.notice)
        })
    }
    
    public var question: AlertMakerExtendable { /// Alert question style
        return self.removeItem(ifExist: .question, closure: { 
            self.makeMoreStyleAlert(.question)
        })
    }
    
    @discardableResult
    public func theme(_ theme: AlertTheme) -> AlertMakerExtendable { /// Customize theme setting
        guard self.description.attributes.contains(.customize) else {
            return self
        }
        self.description.theme = theme
        return self
    }
    
    fileprivate func removeItem(ifExist item: AlertAttributes, closure: () -> Void) -> AlertMakerExtendable {
        if self.description.attributes.contains(item) {
            self.description.attributes -= item
        }
        closure()
        return self
    }
    
    fileprivate func makeMoreStyleAlert(_ style: AlertAttributes) {
        self.description.attributes += .alert
        self.description.attributes += style
    }
    
}
