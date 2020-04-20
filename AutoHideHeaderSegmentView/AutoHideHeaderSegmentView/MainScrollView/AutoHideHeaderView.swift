

import UIKit

protocol AutoHideDelegate: UIView {
    
    
    
}

class AutoHideHeaderView: UIView {

    weak var delegate: AutoHideDelegate?
    weak var superScrollView: UIScrollView?
    weak var scrollView: UIScrollView? {
        get {
            return superScrollView
        }
        
        set {
            superScrollView = newValue
        }
    }
    
}
