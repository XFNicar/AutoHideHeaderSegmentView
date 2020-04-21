//
//  HeaderView.swift
//  AutoHideHeaderSegmentView
//
//  Created by YanYi on 2020/4/21.
//  Copyright © 2020 YanYi. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    class func loadFromNib() -> HeaderView {
        return Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.first as! HeaderView
    }

}
