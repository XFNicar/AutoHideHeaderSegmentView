//
//  SegmentBarCVLayout.swift
//  ScrollListView
//
//  Created by YanYi on 2020/3/11.
//  Copyright © 2020 YanYi. All rights reserved.
//

import UIKit
import ObjectiveC
class SegmentBarCVLayout: UICollectionViewLayout {
    private var attriArray:[UICollectionViewLayoutAttributes] = []
    var frameY:CGFloat = 0
    var frameX:CGFloat = 0
    var contentHeight: CGFloat = 0
    var contentWidth: CGFloat = 0
    var itemHeight: CGFloat = 0
    var itemWidth: CGFloat = 0
    
    init(_ itemWidth: CGFloat, _ itemHeight: CGFloat) {
        super.init()
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        self.contentHeight = itemHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        attriArray.removeAll()
        contentHeight = 0
        contentWidth = 0

        let allSection = self.collectionView?.dataSource?.numberOfSections?(in: self.collectionView!)
        for section in 0...(allSection!-1) {
            let allRow = self.collectionView?.dataSource?.collectionView(self.collectionView!, numberOfItemsInSection: section)
            guard allRow! > 0 else {
                continue
            }
            for row in 0...(allRow! - 1) {
                let indexPath = IndexPath.init(row: row, section: section)
                self.attriArray.append(self.layoutAttributesForItem(at: indexPath )!)
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attri = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        attri.frame = CGRect(x: itemWidth * CGFloat(indexPath.row),
                             y: 0,
                             width:  itemWidth,
                             height: itemHeight)
        contentWidth = itemWidth * CGFloat((indexPath.row + 1))
        return attri
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attriArray
    }
    
    
    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: contentWidth, height:contentHeight)
        }
    }
}
