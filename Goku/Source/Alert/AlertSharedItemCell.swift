//
//  AlertSharedItemCell.swift
//  Goku
//
//  Created by shiwei on 2017/5/27.
//  Copyright © 2017年 shiwei. All rights reserved.
//

import UIKit

internal class AlertSharedItemCell: UICollectionViewCell {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        assembleSeparator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        assembleSeparator()
    }
    
    private func assembleSeparator() {
        let bottomSeparator = UIView(frame: .zero)
        bottomSeparator.backgroundColor = UIColor(hex: 0xCBCBCB)
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(bottomSeparator)
        let bottomSeparatorRight = NSLayoutConstraint(item: bottomSeparator, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let bottomSeparatorLeft = NSLayoutConstraint(item: bottomSeparator, attribute: .left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let bottomSeparatorBottom = NSLayoutConstraint(item: bottomSeparator, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        self.contentView.addConstraints([
                bottomSeparatorBottom,
                bottomSeparatorLeft,
                bottomSeparatorRight
            ])
        
        let separatorHeight = NSLayoutConstraint(item: bottomSeparator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.5)
        bottomSeparator.addConstraint(separatorHeight)
    }
}
