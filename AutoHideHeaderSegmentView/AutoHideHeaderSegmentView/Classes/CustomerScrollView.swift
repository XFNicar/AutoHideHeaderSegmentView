//
//  CustomerScrollView.swift
//  AutoHideHeaderSegmentView
//
//  Created by YanYi on 2020/4/15.
//  Copyright © 2020 YanYi. All rights reserved.
//

import UIKit


class CustomerScrollView: UIScrollView,UIGestureRecognizerDelegate {

    // 该代理解决侧划手势返回上级页面 与 UIScrollView 拖拽手势冲突的问题
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view!.isKind(of: NSClassFromString("UILayoutContainerView")!) {
            if self.contentOffset.x == 0 {
                return true
            }
        }
        return false
    }

}
