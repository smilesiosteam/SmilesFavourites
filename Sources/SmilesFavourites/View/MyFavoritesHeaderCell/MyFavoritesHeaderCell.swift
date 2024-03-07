//
//  MyFavoritesHeaderCell.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 06/03/2024.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager

class MyFavoritesHeaderCell: UITableViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var badgeView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainImage.backgroundColor = .clear
        titleLabel.fontTextStyle = .smilesHeadline2
        titleLabel.textColor = .primaryLabelTextColor
        descLabel.fontTextStyle = .smilesTitle2
        descLabel.textColor = .secondaryLabelTextColor
        badgeLabel.layer.cornerRadius = badgeLabel.frame.size.width * 0.5
        badgeLabel.clipsToBounds = true
        badgeLabel.fontTextStyle = .smilesTitle3
        badgeLabel.textColor = .white
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFirstState() {
        self.mainImage.image = UIImage(named: "ic_favorites_empty")
        self.titleLabel.text = "Your favourite list is empty"
        self.descLabel.text = "Swipe right to add to your favourites.\nTo dismiss it, swipe left"
        self.badgeView.isHidden = true
    }
    
    func setSecondState() {
        self.mainImage.image = UIImage(named: "ic_favorites_empty")
        self.titleLabel.text = "Swipe to add to favorites"
        self.descLabel.text = "added to the list"
        self.badgeView.isHidden = false
    }
    
    func updateBadge(count: Int) {
        self.badgeLabel.text = "\(count)"
    }
    
    func setThirdState() {
        self.mainImage.image = UIImage(named: "ic_favorites_empty")
        self.titleLabel.text = "Great job"
        self.descLabel.text = "Now it’s our turn to get to work. We’ll use your swipes to find you more faves."
        self.badgeView.isHidden = true
    }
    
}
