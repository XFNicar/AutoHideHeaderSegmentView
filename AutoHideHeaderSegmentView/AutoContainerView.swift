//
//  AutoContainerView.swift
//  AutoHideHeaderSegmentView
//
//  Created by YanYi on 2020/4/20.
//  Copyright © 2020 YanYi. All rights reserved.
//

import UIKit

class AutoContainerView: UIView {
    
    
    @IBOutlet weak var shadowView: UIView!
    
    class func loadFromNib() -> AutoContainerView {
        return Bundle.main.loadNibNamed("AutoContainerView", owner: nil, options: nil)?.first as! AutoContainerView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.setShadow(width: 4, bColor: .clear, sColor: .gray, offset: CGSize(width: 0, height: 0), opacity: 0.6, radius: 8)
    }
    
}
