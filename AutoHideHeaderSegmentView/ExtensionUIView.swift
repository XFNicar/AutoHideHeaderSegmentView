

import UIKit


extension UIView {
    func setShadow(width:CGFloat, bColor:UIColor, sColor:UIColor, offset:CGSize, opacity:Float, radius:CGFloat) {
        //设置视图边框宽度
        layer.borderWidth = width
        //设置边框颜色
        layer.borderColor = bColor.cgColor
        //设置边框圆角
        layer.cornerRadius = radius
        //设置阴影颜色
        layer.shadowColor = sColor.cgColor
        //设置透明度
        layer.shadowOpacity = opacity
        //设置阴影半径
        layer.shadowRadius = radius
        //设置阴影偏移量
        layer.shadowOffset = offset
    }
}
