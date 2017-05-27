//
//  AlertSharedItemCell.swift
//  Goku
//
//  Created by shiwei on 2017/5/27.
//  Copyright © 2017年 shiwei. All rights reserved.
//

import UIKit

internal class AlertSharedItemCell: UICollectionViewCell {
    
    lazy private var rightVerticalSeparatorView: UIView = {
        let separator = UIView(frame: .zero)
        separator.backgroundColor = UIColor(hex: 0xCBCBCB)
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    lazy private var bottomSpearatorView: UIView = {
        let bottomSeparator = UIView(frame: .zero)
        bottomSeparator.backgroundColor = UIColor(hex: 0xCBCBCB)
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        return bottomSeparator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        assembleSeparator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func assembleSeparator() {
        
        self.contentView.addSubview(self.bottomSpearatorView)
        self.contentView.addSubview(self.rightVerticalSeparatorView)
        
        let bottomSeparatorRight = NSLayoutConstraint(item: self.bottomSpearatorView, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let bottomSeparatorLeft = NSLayoutConstraint(item: self.bottomSpearatorView, attribute: .left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let bottomSeparatorBottom = NSLayoutConstraint(item: self.bottomSpearatorView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leftSeparatorTopConstraint = NSLayoutConstraint(item: rightVerticalSeparatorView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let leftSeparatorBottomConstraint = NSLayoutConstraint(item: rightVerticalSeparatorView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leftSeparatorLeftConstraint = NSLayoutConstraint(item: rightVerticalSeparatorView, attribute: .left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1.0, constant: 0.0)
        
        self.contentView.addConstraints([
                bottomSeparatorBottom,
                bottomSeparatorLeft,
                bottomSeparatorRight,
                leftSeparatorTopConstraint,
                leftSeparatorLeftConstraint,
                leftSeparatorBottomConstraint
            ])
        
        let separatorHeight = NSLayoutConstraint(item: bottomSpearatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.5)
        bottomSpearatorView.addConstraint(separatorHeight)
        
        let leftSeparatorWidth = NSLayoutConstraint(item: rightVerticalSeparatorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 0.5)
        rightVerticalSeparatorView.addConstraint(leftSeparatorWidth)
    }
}
