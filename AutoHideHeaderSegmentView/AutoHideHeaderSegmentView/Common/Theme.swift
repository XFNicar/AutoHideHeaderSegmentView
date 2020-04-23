//
//  Theme.swift
//  AutoHideHeaderSegmentView
//
//  Created by YanYi on 2020/4/15.
//  Copyright © 2020 YanYi. All rights reserved.
//

import UIKit


public extension UIColor {
    
    /// 0~255 区间的 RGB 值转 UIColor
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: alpha)
    }
    
    static func RGBA(_ R: Int, _ G: Int, _ B: Int,_ A: CGFloat) -> UIColor {
        return UIColor.init(red: R,
                            green: G,
                            blue: B ,
                            alpha: A)
    }
    
    static func HexRGBColor(_ hexRGBValue: Int) -> UIColor {
        return RGBA((hexRGBValue & 0xFF0000) >> 16,
                    (hexRGBValue & 0xFF00) >> 8,
                    (hexRGBValue & 0xFF) >> 0,
                    1.0)
    }
    
    static func HexRGBAlphaColor(_ hexRGBValue: Int, _ alpha: CGFloat) -> UIColor {
        return RGBA((hexRGBValue & 0xFF0000) >> 16,
                    (hexRGBValue & 0xFF00) >> 8,
                    (hexRGBValue & 0xFF) >> 0,
                    alpha)
    }
    
    static func RandomColor() -> UIColor {
        return UIColor.init(red: Int(arc4random_uniform(254)),
                            green: Int(arc4random_uniform(254)),
                            blue: Int(arc4random_uniform(254)) ,
                            alpha: 1)
    }
    
}
