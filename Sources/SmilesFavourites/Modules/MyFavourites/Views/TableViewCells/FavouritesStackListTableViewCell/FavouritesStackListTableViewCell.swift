//
//  MyFavoritesHeaderCell.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 06/03/2024.
//

import UIKit
import SmilesUtilities
import SmilesFontsManager

protocol FavouritesStackListTableViewCellDelegate: AnyObject {
    func didSwipeCard(with card: StackCard?, direction: CardSwipeDirection)
}

final class FavouritesStackListTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var badgeLabel: UILabel!
    @IBOutlet private weak var badgeView: UIView!
    @IBOutlet private weak var stackContainerView: UIView!
    
    // MARK: - Properties
    weak var delegate: FavouritesStackListTableViewCellDelegate?
    private var stackContainer = StackContainerView()
    var swipeCards = [StackCard]()
    var stackListType: StackListType = .voucher

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
    
    func configureCell(with viewModel: ViewModel) {
        delegate = viewModel.delegate
        iconImageView.image = UIImage(resource: viewModel.iconImage ?? .favouritesEmptyIcon)
        titleLabel.text = viewModel.title
        messageLabel.text = viewModel.message
        
        if (viewModel.badgeCount ?? 0) > 0 {
            badgeView.isHidden = false
            badgeLabel.text = "\(viewModel.badgeCount ?? 0)"
        } else {
            badgeView.isHidden = true
        }
        
        swipeCards = viewModel.swipeCards ?? []
        stackListType = viewModel.stackListType
        
        stackContainerView.addSubview(stackContainer)
        stackContainer.frame = stackContainerView.bounds
        stackContainer.delegate = self
        stackContainer.dataSource = self
    }
}

// MARK: ViewModel
extension FavouritesStackListTableViewCell {
    struct ViewModel {
        let iconImage: ImageResource?
        let title: String?
        let message: String?
        let badgeCount: Int?
        let swipeCards: [StackCard]?
        let stackListType: StackListType
        let delegate: FavouritesStackListTableViewCellDelegate?
    }
}

extension FavouritesStackListTableViewCell: SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int {
        return swipeCards.count
    }
    
    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.configureCardType(type: stackListType)
        card.dataSource = swipeCards[index]
        return card
    }
    
    func emptyView() -> UIView? {
        return nil
    }
}

extension FavouritesStackListTableViewCell: StackContainerDelegate {
    func swipeDidEnd(on view: SwipeCardView, direction: CardSwipeDirection) {
        delegate?.didSwipeCard(with: view.dataSource, direction: direction)
    }
}
