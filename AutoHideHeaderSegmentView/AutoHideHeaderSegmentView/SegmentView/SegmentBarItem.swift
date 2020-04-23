//
//  SegmentBarItem.swift
//  ScrollListView
//
//  Created by YanYi on 2020/3/11.
//  Copyright © 2020 YanYi. All rights reserved.
//

import UIKit
import ObjectiveC

@objcMembers open class SegmentBarItem: UICollectionViewCell {
    
    @objc public var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel.init()
        titleLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        addSubview(titleLabel)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func updateUI(_ title: String, titleColor: UIColor, font: UIFont) {
        titleLabel.text = title
        titleLabel.textColor = titleColor
        titleLabel.font = font
    }
    
}
