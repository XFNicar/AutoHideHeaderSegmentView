//
//  AutoHideHeaderSegmentView.swift
//  AutoHideHeaderSegmentView
//
//  Created by YanYi on 2020/4/22.
//  Copyright © 2020 YanYi. All rights reserved.
//


import UIKit
import ObjectiveC


// MARK: AutoHideHeaderSegmentDelegate
@objc public protocol AutoHideHeaderSegmentDelegate: class {
    
    /// 当前 subScrollView index
    @objc optional func mainSegmentView(_ mainSegmentView: AutoHideHeaderSegmentView, didSelectedat index: Int)
    
    /// main ScrollView 滚动时调用
    @objc optional func mainScrollViewDidScroll(_ mainScrollView: UIScrollView)
    
    /// sub ScrollView  滚动时调用
    @objc optional func subScrollViewDidScroll(_ subScrollView: UIScrollView)
     
}


// MARK: AutoHideHeaderSegmentDataSource
@objc public protocol  AutoHideHeaderSegmentDataSource: class {
    
    /// 返回当前index位置pageView
    @objc func mainSegmentView(mainSegmentView: AutoHideHeaderSegmentView, subScrollViewFor index: Int) -> UIScrollView
    
    /// 返回segmentBar的全部标题
    /// 不使用自定义 barItem 时必须实现
    @objc optional func subTitleForPages(mainSegmentView: AutoHideHeaderSegmentView) -> [String]
    
    /// 返回自定义 baritem
    /// 使用自定义 barItem 时必须实现
    @objc optional func mainSegmentView(mainSegmentView: AutoHideHeaderSegmentView, barItemFor indexPath: IndexPath) -> UICollectionViewCell
    
    /// 返回页数
    /// 使用自定义 barItem 时必须实现
    @objc optional func numberOfPages(mainSegmentView: AutoHideHeaderSegmentView) -> Int

//    /// 返回 barItem width
//    @objc optional func mainSegmentView(mainSegmentView: MainSegmentView, barWidthForIndex: Int) -> CGFloat
    
    /// 返回barItem 移动背景
    @objc optional func segmentBarAutoContainerView(mainSegmentView: AutoHideHeaderSegmentView ) -> UIView?
    
    /// 返回 barItem width
    @objc optional func segmentBarItemWidth(mainSegmentView: AutoHideHeaderSegmentView) -> CGFloat
}


@objcMembers

open  class AutoHideHeaderSegmentView: UIView,
UIScrollViewDelegate,
SegmentViewDataSource,
SegmentViewDelegate,
UIGestureRecognizerDelegate {
    
    deinit {
        animator?.removeAllBehaviors()
    }
    
    // MARK: 代理
    @objc public weak var delegate: AutoHideHeaderSegmentDelegate?
    
    
    // MARK: 数据源
    @objc public weak var dataSource: AutoHideHeaderSegmentDataSource?
    
    // MARK: 头部最大滚动高度
    public var maxTopScrollHeight: CGFloat?
    
    
    // MARK: 设置 HeadView
    @objc public var autoHeaderView: UIView {
        set {
            headView.removeFromSuperview()
            headView = newValue
            headView.frame = CGRect(x: 0, y: 0, width: frame.width, height: newValue.frame.height * (frame.width / newValue.frame.width))
            mainScrollView.addSubview(headView)
            mainScrollView.contentSize = CGSize(width: 0, height: frame.height + topHeight)
        }
        get {
            return headView
        }
    }
    
    // MARK: 是否自定义segmentBarItem
    /// 如需自定义baritem 务必设置 isCustomerBarItem = true 否则不会走 自定义cell dataSource
    @objc public var isCustomerBarItem: Bool {
        get { return segmentView.isCustomerBarItem }
        set { segmentView.isCustomerBarItem = newValue }
    }
    
    
    private lazy var segmentView: SegmentView = {
        let sView = SegmentView.init(frame: CGRect(x: 0, y: topHeight, width: frame.width, height: frame.height))
        sView.dataSource = self
        sView.delegate = self
        sView.barBackGroundColor = .HexRGBColor(0xF5F7FA)
        sView.barTitleFont = UIFont.systemFont(ofSize: 14)
        sView.scrollBounces = true
        return sView
    }()
    
    private lazy var mainScrollView: UIScrollView = {
        let mScrollView = UIScrollView.init(frame: frame)
        mScrollView.isScrollEnabled = false
        mScrollView.isPagingEnabled = true
        mScrollView.delegate = self
        return mScrollView
    }()
    private var headView: UIView = UIView()
    private var currentSubScrollView: UIScrollView?
    private var subScrollViews: [UIScrollView] = []
    private var animator: UIDynamicAnimator?
    private weak var decelerationBehavior: UIDynamicItemBehavior?
    private var dynamicItem: DynamicItem = DynamicItem()
    private weak var springBehavior: UIAttachmentBehavior?
    private var pan: UIPanGestureRecognizer?
    private var isVertical: Bool = false
    
    
    private var topHeight: CGFloat {
        get {
            if maxTopScrollHeight != nil { return maxTopScrollHeight! }
            return headView.frame.height
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubViews() {
        addSubview(mainScrollView)
        headView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 150)
//        headView.backgroundColor = .RandomColor()
        mainScrollView.addSubview(headView)
        mainScrollView.contentSize = CGSize(width: 0, height: frame.height + topHeight)
        mainScrollView.addSubview(segmentView)
        pan = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureRecognizerAction))
        pan?.delegate = self
        addGestureRecognizer(pan!)
        animator = UIDynamicAnimator.init(referenceView: self)
    }
    
   @objc public func reloadData() {
        
        reConfigureSubViews()
        if dataSource != nil {
            segmentView.reloadData()
        } else {
            print("Segment DataSource -【Error】:请设置MainSegmentView 的 DataSource")
        }
    }
    
    private func reConfigureSubViews() {
        if maxTopScrollHeight != nil {
            segmentView.frame = CGRect(x: 0, y: headView.frame.height, width: frame.width, height: frame.height -  (headView.frame.height - maxTopScrollHeight!))
        }
    }

}


// MARK: 有关segmentView Delegate && DataSource
@objc public extension AutoHideHeaderSegmentView {
    
   @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(mainScrollView) {
            if self.delegate?.mainScrollViewDidScroll?(scrollView) != nil { }
        } else {
            if self.delegate?.subScrollViewDidScroll?(scrollView) != nil { }
        }
    }
    
   @objc func segmentView(segmentView: SegmentView, subViewWith index: Int) -> UIView {
        
        var subView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        if dataSource != nil {
            subView = dataSource!.mainSegmentView(mainSegmentView: self, subScrollViewFor: index)
            subScrollViews.append(subView)
        }
        if index == 0 {
            currentSubScrollView = subView
        }
        subView.isScrollEnabled = false
        return subView
    }
    
   @objc func subTitleWithPages(segmentView: SegmentView) -> [String] {
        if dataSource != nil {
            return dataSource!.subTitleForPages!(mainSegmentView: self)
        }
        return []
    }
    
    @objc func numberOfPages(segmentView: SegmentView) -> Int {
        return (dataSource?.numberOfPages!(mainSegmentView: self))!
    }
    
    @objc func segmentView(segmentView: SegmentView, barItemFor indexPath: IndexPath) -> UICollectionViewCell {
        return (dataSource?.mainSegmentView!(mainSegmentView: self, barItemFor: indexPath))!
    }
    
    /// 返回barItem 移动背景
    @objc func segmentBarAutoContainerView(segmentView: SegmentView ) -> UIView? {
        return dataSource?.segmentBarAutoContainerView?(mainSegmentView: self)
    }
    
    @objc func segmentBarItemWidth(segmentView: SegmentView) -> CGFloat {
        return (dataSource?.segmentBarItemWidth?(mainSegmentView: self))!
    }
    
    // MARK: 注册 BarItemCell
    @objc func registBarItemClass(_ cellClass: AnyClass?, forCellWithReuseIdentifier: String ) {
        segmentView.registBarItemClass(cellClass, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }
    
    @objc func registBarItemNib(_ nib: UINib?, forCellWithReuseIdentifier: String) {
        segmentView.registBarItemNib(nib, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }
    
   @objc func dequeueReusableCell(withReuseIdentifier: String, forIndexPath: IndexPath) -> UICollectionViewCell? {
        return segmentView.dequeueReusableCell(withReuseIdentifier: withReuseIdentifier, forIndexPath: forIndexPath)
    }
    
   @objc func segmentView(segmentView: SegmentView, didEndScroll atIndex: Int) {
        currentSubScrollView = subScrollViews[atIndex]
        if delegate?.mainSegmentView?(self, didSelectedat: atIndex) != nil {
        }

    }
}


// MARK: 处理手势冲突问题
extension AutoHideHeaderSegmentView {
    @objc func panGestureRecognizerAction(recognizer: UIPanGestureRecognizer)  {
        switch recognizer.state {
        case .began:
            let currentY = recognizer.translation(in: self).y
            let currentX = recognizer.translation(in: self).x
            if currentY == 0.0 {
                isVertical = false
            } else {
                if abs(currentX) / currentY >= 5.0 {
                    isVertical = false
                } else {
                    isVertical = true
                }
            }
            animator?.removeAllBehaviors()
            break
        case .changed:
            if isVertical {
                let currentY = recognizer.translation(in: self).y
                controlScroll(currentY, state: .changed)
            }
            break
        case .cancelled:
            
            break
        case .ended:
            if isVertical {
                dynamicItem.center = self.bounds.origin
                let velocity = recognizer.velocity(in: self)
                let inertialBehavior = UIDynamicItemBehavior.init(items: [dynamicItem])
                inertialBehavior.addLinearVelocity(CGPoint(x: 0, y: velocity.y), for: dynamicItem)
                inertialBehavior.resistance = 2.0
                var lastCenter = CGPoint.zero
                inertialBehavior.action = { [weak self] in
                    if (self?.isVertical)! {
                        let currentY = (self?.dynamicItem.center.y)! - lastCenter.y
                        self?.controlScroll(currentY, state: .ended)
                    }
                    lastCenter = (self?.dynamicItem.center)!
                }
                animator?.addBehavior(inertialBehavior)
                decelerationBehavior = inertialBehavior
            }
            break
        default:
            break
        }
        recognizer.setTranslation(CGPoint.zero, in: self)
    }
    
    func controlScroll(_ forVertical: CGFloat, state: UIGestureRecognizer.State) {
        if self.mainScrollView.contentOffset.y >= topHeight {
            var offsetY = (currentSubScrollView?.contentOffset.y)! - forVertical
            if offsetY < 0 {
                offsetY = 0
                mainScrollView.contentOffset = CGPoint(x: mainScrollView.frame.origin.x, y: mainScrollView.contentOffset.y - forVertical)
            } else if offsetY > (currentSubScrollView?.contentSize.height)! - (currentSubScrollView?.frame.size.height)! {
                offsetY = (currentSubScrollView?.contentOffset.y)! - rubberBandDistance(forVertical, dimension: mainScrollView.frame.height)
            }
            currentSubScrollView?.contentOffset = CGPoint(x: 0, y: offsetY)
        } else {
            var mainOffsetY = mainScrollView.contentOffset.y - forVertical
            if mainOffsetY < 0 {
                mainOffsetY = mainScrollView.contentOffset.y - rubberBandDistance(forVertical, dimension: mainScrollView.frame.height)
                
            } else if mainOffsetY > topHeight {
                mainOffsetY = topHeight
            }
            
            mainScrollView.contentOffset = CGPoint(x: mainScrollView.frame.origin.x, y: mainOffsetY)
            if mainOffsetY == 0 {
                for item in subScrollViews {
                    item.contentOffset = CGPoint(x: 0, y: 0)
                }
            }
        }
        
        let isOutSideFrame: Bool = outSideFrame()
        if isOutSideFrame && (decelerationBehavior != nil && springBehavior == nil) {
            var target: CGPoint = CGPoint.zero
            var isMain = false
            if mainScrollView.contentOffset.y < 0 {
                dynamicItem.center = mainScrollView.contentOffset
                target = .zero
                isMain = true
            } else if (currentSubScrollView?.contentOffset.y)! > ((currentSubScrollView?.contentSize.height)! - (currentSubScrollView?.frame.height)!) {
                dynamicItem.center = (currentSubScrollView?.contentOffset)!
                target.x = (currentSubScrollView?.contentOffset.x)!
                target.y = (currentSubScrollView?.contentSize.height)! > (currentSubScrollView?.frame.height)! ? ((currentSubScrollView?.contentSize.height)! - (currentSubScrollView?.frame.height)!) : 0
                isMain = false
            }
            
            animator?.removeBehavior(decelerationBehavior!)
            let springBeh: UIAttachmentBehavior = UIAttachmentBehavior.init(item: dynamicItem, attachedToAnchor: target)
            springBeh.length = 0
            springBeh.damping = 1
            springBeh.frequency = 2
            springBeh.action = { [weak self] in
                if isMain {
                    self?.mainScrollView.contentOffset = (self?.dynamicItem.center)!
                    if self?.mainScrollView.contentOffset.y == 0 {
                        for item in (self?.subScrollViews)! {
                            item.contentOffset = CGPoint(x: 0, y: 0)
                        }
                    }
                } else {
                    self?.currentSubScrollView?.contentOffset = (self?.dynamicItem.center)!
                    // 这里可以处理加载逻辑,contentoffset.y + 刷新空间高度
                    //                    if self?.currentSubScrollView.mj_footer.refreshing {
                    //                        self?.currentSubScrollView?.contentOffset = CGPoint(x: (self?.currentSubScrollView?.contentOffset.x)!, y: (self?.currentSubScrollView?.contentOffset.x)! + 44)
                    //                    }
                }
            }
            self.animator?.addBehavior(springBeh)
            springBehavior = springBeh
        }
    }
    
    func outSideFrame() -> Bool {
        if  mainScrollView.contentOffset.y < 0 {
            return true
        }
        
        if (currentSubScrollView?.contentSize.height)! > (currentSubScrollView?.frame.height)! {
            if (currentSubScrollView?.contentOffset.y)! > ((currentSubScrollView?.contentSize.height)! - (currentSubScrollView?.frame.height)!) {
                return true
            }
            return false
        } else {
            if (currentSubScrollView?.contentOffset.y)! > 0 {
                return true
            }
            return false
        }
    }
    
    func rubberBandDistance(_ offset: CGFloat, dimension: CGFloat) -> CGFloat {
        let constant: CGFloat = 0.55
        let resultA = constant * abs(offset) * dimension
        let resultB = dimension + constant * abs(offset)
        let result = resultA/resultB
        return offset < 0.0 ? -result : result
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            let recognizer = gestureRecognizer as! UIPanGestureRecognizer
            let currentY = recognizer.translation(in: self).y
            let currentX = recognizer.translation(in: self).x
            if currentY == 0.0 {
                return true
            } else {
                if abs(currentX) / currentY >= 5.0 {
                    return true
                } else {
                    return false
                }
            }
        }
        return false
    }
    
    class DynamicItem: NSObject, UIDynamicItem {
        
        private var pCenter: CGPoint = .zero
        var center: CGPoint {
            get {
                return pCenter
            }
            set {
                pCenter = newValue
            }
        }
        
        private var pTransform: CGAffineTransform = CGAffineTransform.init()
        var transform: CGAffineTransform {
            get {
                return pTransform
            }
            
            set {
                pTransform = newValue
            }
        }
        
        private var pBounds: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        var bounds: CGRect {
            get {
                return pBounds
            }
        }
    }
}

