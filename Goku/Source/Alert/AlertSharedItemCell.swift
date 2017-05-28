//
//  AlertSharedItemCell.swift
//  Goku
//
//  Created by shiwei on 2017/5/27.
//  Copyright © 2017年 shiwei. All rights reserved.
//

import UIKit

internal class AlertSharedItemCell: UICollectionViewCell {
    
    lazy public var rightVerticalSeparatorView: UIView = {
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
    
    lazy private var sharedTitleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = UIColor(hex: 0x000000)
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy private var sharedPlatformImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        assembleSeparator()
        configurationSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func bindAlertSharedItem(_ item: AlertSharedItem) {
        self.sharedTitleLabel.text = item.platform
        if let platform = UIImage(named: item.platformImage) {
            self.sharedPlatformImageView.image = platform
            let width = platform.size.width
            let height = platform.size.height
            
            let ratio = width / height // Ratio of width and height
            
            let newWidth = ratio * 28
            let platformImageViewHeightConstraint = NSLayoutConstraint(item: self.sharedPlatformImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 28.0)
            let platformImageViewWidthConstraint = NSLayoutConstraint(item: self.sharedPlatformImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: newWidth)
            self.sharedPlatformImageView.addConstraints([
                    platformImageViewWidthConstraint,
                    platformImageViewHeightConstraint
                ])
        }
    }
    
    private func assembleSeparator() {
        
        self.contentView.addSubview(self.bottomSpearatorView)
        self.contentView.addSubview(self.rightVerticalSeparatorView)
        
        let bottomSeparatorRight = NSLayoutConstraint(item: self.bottomSpearatorView, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let bottomSeparatorLeft = NSLayoutConstraint(item: self.bottomSpearatorView, attribute: .left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let bottomSeparatorBottom = NSLayoutConstraint(item: self.bottomSpearatorView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leftSeparatorTopConstraint = NSLayoutConstraint(item: rightVerticalSeparatorView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let leftSeparatorBottomConstraint = NSLayoutConstraint(item: rightVerticalSeparatorView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leftSeparatorRightConstraint = NSLayoutConstraint(item: rightVerticalSeparatorView, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1.0, constant: 0.0)
        
        self.contentView.addConstraints([
                bottomSeparatorBottom,
                bottomSeparatorLeft,
                bottomSeparatorRight,
                leftSeparatorTopConstraint,
                leftSeparatorRightConstraint,
                leftSeparatorBottomConstraint
            ])
        
        let separatorHeight = NSLayoutConstraint(item: bottomSpearatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.5)
        bottomSpearatorView.addConstraint(separatorHeight)
        
        let leftSeparatorWidth = NSLayoutConstraint(item: rightVerticalSeparatorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 0.5)
        rightVerticalSeparatorView.addConstraint(leftSeparatorWidth)
    }
    
    private func configurationSubViews() {
        self.contentView.addSubview(sharedPlatformImageView)
        self.contentView.addSubview(sharedTitleLabel)
        
        let imageViewTopConstraint  = NSLayoutConstraint(item: self.sharedPlatformImageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 8.0)
        let imageViewCenterConstraint = NSLayoutConstraint(item: self.sharedPlatformImageView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let platformLabelTopConstraint = NSLayoutConstraint(item: self.sharedTitleLabel, attribute: .top, relatedBy: .equal, toItem: sharedPlatformImageView, attribute: .bottom, multiplier: 1.0, constant: 6.0)
        let platformLabelLeftConstraint = NSLayoutConstraint(item: self.sharedTitleLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let platformLabelRigthConstraint = NSLayoutConstraint(item: self.sharedTitleLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: 0.0)
        
        self.contentView.addConstraints([
                imageViewTopConstraint,
                imageViewCenterConstraint,
                platformLabelTopConstraint,
                platformLabelLeftConstraint,
                platformLabelRigthConstraint
            ])
        
        let platformLabelHeightConstraint = NSLayoutConstraint(item: sharedTitleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 14.0)
        sharedTitleLabel.addConstraint(platformLabelHeightConstraint)
    }
}
