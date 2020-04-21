//
//  SegmentBar.swift
//  ScrollListView
//
//  Created by YanYi on 2020/3/11.
//  Copyright © 2020 YanYi. All rights reserved.
//

import UIKit

@objc public protocol SegmentBarDataSource: class {
    @objc func segmentBar(segmentBar: SegmentBar, barItemFor indexPath: IndexPath) -> UICollectionViewCell
    /// 返回一共有多少页面
    func numberOfItems(segmentBar: SegmentBar) -> Int
    
    /// 返回 barItem width
    @objc optional func segmentBarItemWidth(segmentBar: SegmentBar) -> CGFloat
    
    /// 返回 默认模式 下所有标题
    @objc optional func segmentBarItemTitles(segmentBar: SegmentBar) -> [String]
    
    /// 返回barItem 移动背景
    @objc optional func segmentBarAutoContainerView(setmentBar: SegmentBar ) -> UIView?
}




open class SegmentBar: UIView,UICollectionViewDataSource {
    
    
    weak var dataSource: SegmentBarDataSource?
    var isCustomerBarItem: Bool = false
    weak var contentScrollView: UIScrollView?
    var barCollectionView: UICollectionView!
    
    private var items: [String] = []
    var barHeight: CGFloat = 45
    var layout: SegmentBarCVLayout!
    var lineView: UIView = UIView()
    var autoContainer: UIView?
    
    var currentIndex: Int = 0
    var lineWidth: CGFloat {
        set {
             lineView.frame = CGRect(x: (newValue - newValue) / 2, y: lineOrginY, width: newValue, height: 2)
        }
        get {
            return lineView.frame.width
        }
    }
    var lineOrginY: CGFloat {
        get {
            return frame.height - 2
        }
    }
    var subTitleFont: UIFont = UIFont.systemFont(ofSize: 14)
    var selectedTitleColor: UIColor = .HexRGBColor(0x0D5EDA)
    var deSelectedTitleColor: UIColor = .HexRGBColor(0x646D76)
    private var cellIdentifer: String = "defaultId"
    
    var titleFont : UIFont {
        set {
            subTitleFont = newValue
            barCollectionView.reloadData()
        }
        get { return subTitleFont }
    }
    
    var selectedIndex: Int {
        set {
            currentIndex = newValue
            barCollectionView.reloadData()
        }
        get { return currentIndex }
    }
    var itemWidth: CGFloat = 0
    
    var barItems: [String] {
        get { return items }
        set {
            items = newValue
            lineView.frame = CGRect(x: (itemWidth - lineWidth) / 2, y: lineOrginY, width: lineWidth, height: 2)
            self.barCollectionView.reloadData()
        }
    }
    
    var contentWidth: CGFloat {
        get { return itemWidth * CGFloat(items.count) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        barHeight = frame.height
        layout = SegmentBarCVLayout(65, frame.height - 2)
        barCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: layout)
        barCollectionView.register(SegmentBarItem.self, forCellWithReuseIdentifier: cellIdentifer)
        barCollectionView.dataSource = self
        addSubview(barCollectionView)
        backgroundColor = .clear
        barCollectionView.backgroundColor = .clear
        lineView.backgroundColor = .HexRGBColor(0x0D5EDA)
        barCollectionView.addSubview(lineView)
        barCollectionView.showsHorizontalScrollIndicator = false
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        let iWidth: CGFloat = (dataSource?.segmentBarItemWidth?(segmentBar: self))!
        itemWidth = iWidth
        lineWidth = iWidth
        lineView.frame = CGRect(x: (itemWidth - lineWidth) / 2, y: lineOrginY, width: lineWidth, height: 2)
        if isCustomerBarItem {
            layout.itemHeight = frame.height
            layout.itemWidth = itemWidth
        } else {
            items.removeAll()
            items.append(contentsOf: (dataSource?.segmentBarItemTitles?(segmentBar: self))!)
            layout.itemHeight = frame.height
            layout.itemWidth = itemWidth
        }
        
        if let autoView = dataSource?.segmentBarAutoContainerView?(setmentBar: self) {
            autoContainer = autoView
            autoContainer?.frame = CGRect(x: 0, y: 0, width: itemWidth, height: barHeight)
            autoContainer?.layoutIfNeeded()
            insertSubview(autoContainer!, at: 0)
        }
        
        if isCustomerBarItem {
            lineView.alpha = 0
        } else {
            lineView.alpha = 1
        }
        barCollectionView.reloadData()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataSource?.numberOfItems(segmentBar: self))!
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 自定义bar
        if isCustomerBarItem {
            return (dataSource?.segmentBar(segmentBar: self, barItemFor: indexPath))!
        }
        
        /// 默认的 barItem
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifer, for: indexPath) as! SegmentBarItem
        if currentIndex == indexPath.row {
            cell.updateUI(items[indexPath.row], titleColor: selectedTitleColor, font: subTitleFont)
        } else {
            cell.updateUI(items[indexPath.row], titleColor: deSelectedTitleColor, font: subTitleFont)
        }
        return cell
    }
    
    func dequeueReusableCell(withReuseIdentifier: String, forIndexPath: IndexPath) -> UICollectionViewCell? {
        return barCollectionView.dequeueReusableCell(withReuseIdentifier: withReuseIdentifier, for: forIndexPath)
    }
    

}
