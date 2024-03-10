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

class MyFavoritesSegmentCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        titleLabel.fontTextStyle = .smilesTitle1
        titleLabel.textColor = .foodEnableColor
        borderView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 6)
    }
    
    private func selectedState() {
        titleLabel.textColor = .foodEnableColor
        borderView.isHidden = false
    }
    
    private func deselectedState() {
        titleLabel.textColor = .appRevampFoodDisableIconGrayColor
        borderView.isHidden = true
    }
    
    // MARK: - Public Methods
    func configureCell(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        viewModel.isSelected ? selectedState() : deselectedState()
    }
}

// MARK: - ViewModel
extension MyFavoritesSegmentCollectionViewCell {
    struct ViewModel {
        let title: String?
        let isSelected: Bool
    }
}
