//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 22/03/2024.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager

final class SwipeMessageTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var badgeLabel: UILabel!
    @IBOutlet private weak var badgeView: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods
    private func setupUI() {
        iconImageView.backgroundColor = .clear
        
        titleLabel.fontTextStyle = .smilesHeadline2
        titleLabel.textColor = .primaryLabelTextColor
        
        messageLabel.fontTextStyle = .smilesTitle2
        messageLabel.textColor = .secondaryLabelTextColor
        
        badgeLabel.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: badgeLabel.bounds.height / 2)
        badgeLabel.fontTextStyle = .smilesTitle3
        badgeLabel.textColor = .white
        
        containerStackView.setCustomSpacing(24, after: iconImageView)
        containerStackView.setCustomSpacing(56, after: titleStackView)
    }
    
    func configureCell(with viewModel: SwipeMessageViewModel) {
        if let iconImage = viewModel.iconImage {
            iconImageView.image = UIImage(named: iconImage, in: .module, with: nil)
        }
        titleLabel.text = viewModel.title
        messageLabel.text = viewModel.message
        
        if (viewModel.badgeCount ?? 0) > 0 {
            badgeView.isHidden = false
            badgeLabel.text = "\(viewModel.badgeCount ?? 0)"
        } else {
            badgeView.isHidden = true
        }
    }
}

// MARK: SwipeMessageViewModel
struct SwipeMessageViewModel: Codable {
    let iconImage: String?
    let title: String?
    let message: String?
    let badgeCount: Int?
}
