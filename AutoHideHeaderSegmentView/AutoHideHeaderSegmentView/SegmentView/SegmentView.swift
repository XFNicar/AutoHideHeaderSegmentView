//
//  SegmentView.swift
//  ScrollListView
//
//  Created by YanYi on 2020/3/11.
//  Copyright © 2020 YanYi. All rights reserved.
//

import UIKit

@objc public protocol SegmentViewDataSource: class {
    /// 返回当前index位置pageView
    func segmentView(segmentView: SegmentView, subViewWith index: Int) -> UIView
    
    /// 返回segmentBar的全部标题
    func subTitleWithPages(segmentView: SegmentView) -> [String]
    
    /// 返回一共有多少页面
    @objc func numberOfPages(segmentView: SegmentView) -> Int
    
    /// 返回 barItem width
    @objc optional func segmentView(segmentView: SegmentView, barWidthForIndex: Int) -> CGFloat
    
    /// 返回 自定义baritem
    @objc func segmentView(segmentView: SegmentView, barItemFor indexPath: IndexPath) -> UICollectionViewCell
    
    /// 返回barItem 移动背景
    @objc optional func segmentBarAutoContainerView(segmentView: SegmentView ) -> UIView?
    
    /// 返回 barItem width
    @objc optional func segmentBarItemWidth(segmentView: SegmentView) -> CGFloat
}

@objc public protocol SegmentViewDelegate: class {
    @objc optional func segmentView(segmentView: SegmentView, didEndScroll atIndex: Int)
}



open class SegmentView: UIView,UICollectionViewDelegate,SegmentBarDataSource {
   
    

    weak var dataSource: SegmentViewDataSource?
    weak var delegate: SegmentViewDelegate?
        
//
//    var barLineWidth: CGFloat {
//        set { segmentBar.lineWidth = newValue }
//        get { return segmentBar.lineWidth }
//    }
    
    var barBackGroundColor: UIColor? {
        set { segmentBar.backgroundColor = newValue }
        get { return segmentBar.backgroundColor }
    }
    
    var barTitleFont: UIFont {
        set { segmentBar.titleFont = newValue }
        get { return segmentBar.titleFont }
    }
    
    // MARK: 是否自定义segmentBarItem
    var isCustomerBarItem: Bool {
        get { return segmentBar.isCustomerBarItem }
        set { segmentBar.isCustomerBarItem = newValue }
    }
    
    var scrollBounces: Bool {
        set { myScrollView.bounces = newValue }
        get { return myScrollView.bounces }
    }
    
    private var myScrollView: CustomerScrollView!
    
    private lazy var segmentBar: SegmentBar = {
        let sbar = SegmentBar.init(frame: CGRect(x: 0, y: 0, width:frame.width, height: 50))
        sbar.barCollectionView?.delegate = self
        sbar.dataSource = self
        return sbar
    }()
    
    private var subPageViews: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 刷新数据
    func reloadData() {
        var pageCount: Int = 0
        if isCustomerBarItem {
            pageCount = (dataSource?.numberOfPages(segmentView: self))!
        } else {
            segmentBar.barItems = (dataSource?.subTitleWithPages(segmentView: self))!
            pageCount = segmentBar.barItems.count
        }
        
        segmentBar.reloadData()
        myScrollView.contentSize = CGSize(width: CGFloat(pageCount) * frame.width, height: frame.height - segmentBar.barHeight)
        if pageCount == 0 {
            return
        }
        for index in 0...(pageCount-1) {
            let itemView = dataSource?.segmentView(segmentView: self, subViewWith: index)
            itemView?.frame =  CGRect(x: CGFloat(index) * frame.width , y: 0, width: frame.width, height: frame.height - segmentBar.barHeight)
            myScrollView.addSubview(itemView!)
        }
    }
    
    public func numberOfItems(segmentBar: SegmentBar) -> Int {
        return (dataSource?.numberOfPages(segmentView: self))!
    }
    
    public func segmentBarItemTitles(segmentBar: SegmentBar) -> [String] {
        return (dataSource?.subTitleWithPages(segmentView: self))!
    }
    
    public func segmentBarAutoContainerView(setmentBar: SegmentBar) -> UIView? {
        return dataSource?.segmentBarAutoContainerView?(segmentView: self)
    }
    
    public func segmentBarItemWidth(segmentBar: SegmentBar) -> CGFloat {
        return (dataSource?.segmentBarItemWidth?(segmentView: self))!
    }
    
    // MARK: 注册 BarItemCell
    func registBarItem(_ cellClass: AnyClass?, forCellWithReuseIdentifier: String ) {
        segmentBar.barCollectionView.register(cellClass, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }
    
    func registBarItem(_ nib: UINib?, forCellWithReuseIdentifier: String) {
        segmentBar.barCollectionView.register(nib, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }

    // MARK: 自定义 BarItem DataSource
    public func segmentBar(segmentBar: SegmentBar, barItemFor indexPath: IndexPath) -> UICollectionViewCell {
        return (dataSource?.segmentView(segmentView: self, barItemFor: indexPath))!
    }
    
    func dequeueReusableCell(withReuseIdentifier: String, forIndexPath: IndexPath) -> UICollectionViewCell? {
        return segmentBar.dequeueReusableCell(withReuseIdentifier: withReuseIdentifier, forIndexPath: forIndexPath)
    }
    
    
    private func configUI()  {
        addSubview(segmentBar)
        myScrollView = CustomerScrollView.init(frame: CGRect(x: 0, y: segmentBar.barHeight, width: frame.width, height: frame.height - segmentBar.barHeight))
        myScrollView.isPagingEnabled = true
        myScrollView.showsHorizontalScrollIndicator = false
        myScrollView.bounces = false
        addSubview(myScrollView)
        myScrollView.delegate = self
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        myScrollView.setContentOffset(CGPoint(x: CGFloat(indexPath.row) * collectionView.frame.width, y: 0), animated: true)
        segmentBar.selectedIndex = indexPath.row
        if delegate != nil {
            delegate?.segmentView?(segmentView: self, didEndScroll: indexPath.row)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         
        if scrollView.isEqual(myScrollView) {
            let scrollToScrollStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
            if scrollToScrollStop {
                scrollViewDidEndenScroll(scrollView)
            }
        }
     }
     
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.isEqual(myScrollView) {
            let  scrollToScrollStop = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
            if scrollToScrollStop {
                scrollViewDidEndenScroll(scrollView)
            }
        }
         
     }
    
    func scrollViewDidEndenScroll(_ scrollView: UIScrollView)  {
        
        if scrollView.isEqual(myScrollView) {
            let contentX = scrollView.contentOffset.x
            let index = contentX / scrollView.frame.width
            segmentBar.selectedIndex = lround(Double(index))
            if delegate != nil {
                delegate?.segmentView?(segmentView: self, didEndScroll: lround(Double(index)))
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.isEqual(myScrollView) {
            let contentX = scrollView.contentOffset.x
            let index = contentX / scrollView.frame.width
            segmentBar.lineView.frame = CGRect(x: index * segmentBar.itemWidth + (segmentBar.itemWidth - segmentBar.lineWidth) / 2,
                                               y: segmentBar.frame.height - 2,
                                               width: segmentBar.lineWidth,
                                               height: 2)
            let aViewFrame = segmentBar.autoContainer?.frame
            if segmentBar.autoContainer != nil {
                if (index * segmentBar.itemWidth + (segmentBar.itemWidth - aViewFrame!.width) / 2 >= 0) && (index * segmentBar.itemWidth + (segmentBar.itemWidth - aViewFrame!.width + segmentBar.itemWidth) <= segmentBar.frame.width) {
                    
                    segmentBar.autoContainer!.frame = CGRect(x: index * segmentBar.itemWidth + (segmentBar.itemWidth - aViewFrame!.width) / 2,
                                                             y: 0,
                                                             width: segmentBar.itemWidth,
                                                             height: aViewFrame!.height)
                }
            }
            if segmentBar.lineView.frame.origin.x > scrollView.frame.width - segmentBar.lineWidth {
                segmentBar.barCollectionView.scrollToItem(at: IndexPath.init(row: Int(index), section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
            }
        }
    }

}
