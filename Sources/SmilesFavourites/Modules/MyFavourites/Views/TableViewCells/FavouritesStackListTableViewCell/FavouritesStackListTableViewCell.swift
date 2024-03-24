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
    @IBOutlet private weak var stackContainerView: StackContainerView!
    
    // MARK: - Properties
    weak var delegate: FavouritesStackListTableViewCellDelegate?
    private var stackContainer = StackContainerView()
    var swipeCards = [StackCard]()
    var stackListType: StackListType = .voucher

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods
    func configureCell(with viewModel: ViewModel, shouldSkeleton: Bool) {
        delegate = viewModel.delegate
        
        swipeCards = viewModel.swipeCards ?? []
        stackListType = viewModel.stackListType
        
        stackContainerView.addSubview(stackContainer)
        stackContainer.frame = stackContainerView.bounds
        stackContainer.setShouldSkeleton(shouldSkeleton: shouldSkeleton)
        stackContainer.delegate = self
        stackContainer.dataSource = self
    }
}

// MARK: ViewModel
extension FavouritesStackListTableViewCell {
    struct ViewModel {
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
