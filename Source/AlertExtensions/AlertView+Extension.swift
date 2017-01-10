//  AlertView+Extension.swift
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

private extension Selector {
    static let viewAction = #selector(UIView.tapped(_:))
}

internal class GokuAction: NSObject {
    var actionDictionary: Dictionary<NSValue, () -> ()> = Dictionary()
    static let shared = GokuAction()
    override fileprivate init() { }
}

public extension UIView {
    func action(_ f: @escaping () -> ()) {
        let tap = UITapGestureRecognizer(target: self, action: .viewAction)
        self.addGestureRecognizer(tap)
        GokuAction.shared.actionDictionary[NSValue(nonretainedObject: self)] = f
    }
    
    @objc fileprivate func tapped(_ tap: UITapGestureRecognizer) {
        if let closure = GokuAction.shared.actionDictionary[NSValue(nonretainedObject: tap.view)] {
            closure()
        } else { }
    }
}

internal extension String {
    func height(_ width: CGFloat, font: UIFont, lineBreakMode: NSLineBreakMode?) -> CGFloat {
        var attrib: [String: AnyObject] = [NSFontAttributeName: font]
        if lineBreakMode != nil {
            let paragraphStyle = NSMutableParagraphStyle();
            paragraphStyle.lineBreakMode = lineBreakMode!;
            attrib.updateValue(paragraphStyle, forKey: NSParagraphStyleAttributeName);
        }
        let size = CGSize(width: width, height: CGFloat(DBL_MAX));
        return ceil((self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attrib, context: nil).height)
    }
}
