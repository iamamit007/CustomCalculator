//
//  DigitsViewCell.swift
//  CustomCalculator
//
//  Created by Amit on 09/08/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit

class DigitsViewCell: UICollectionViewCell {
    
    
 
    @IBOutlet weak var topdistance: NSLayoutConstraint!
    
    
    @IBOutlet weak var label: UILabel!
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//       
//        //hide or reset anything you want hereafter, for example
//       // label.isHidden = true
//        
//    }
    
    var shouldSnapshot = false
    
    override func snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
        if shouldSnapshot {
            shouldSnapshot = false
            return super.snapshotView(afterScreenUpdates: afterUpdates)
        } else {
            return nil
        }
    }
    
}
