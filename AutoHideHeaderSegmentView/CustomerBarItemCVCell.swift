//
//  CustomerBarItemCVCell.swift
//  AutoHideHeaderSegmentView
//
//  Created by YanYi on 2020/4/17.
//  Copyright © 2020 YanYi. All rights reserved.
//

import UIKit

class CustomerBarItemCVCell: UICollectionViewCell {

    
    @IBOutlet weak var barNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateUI(title: String) {
        barNameLabel.text = title
    }

}
