//
//  MyFavoritesSegmentCell.swift
//  House
//
//  Created by Hafiz Muhammad Junaid on 05/03/2024.
//  Copyright © 2024 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager

class MyFavoritesSegmentCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLabel.fontTextStyle = .smilesTitle1
        nameLabel.textColor = .foodEnableColor
        DispatchQueue.main.async {
            self.borderView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 6)
        }
    }
    
    func selectedState() {
        nameLabel.textColor = .foodEnableColor
        self.borderView.isHidden = false
    }
    
    func deslectedState() {
        nameLabel.textColor = .appRevampFoodDisableIconGrayColor
        self.borderView.isHidden = true
    }

}
