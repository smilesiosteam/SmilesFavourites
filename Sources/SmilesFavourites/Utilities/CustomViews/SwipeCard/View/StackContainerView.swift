//
//  StackContainerController.swift
//  TinderStack
//
//  Created by Osama Naeem on 16/03/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import UIKit

protocol StackContainerDelegate: AnyObject {
    func swipeDidEnd(on view: SwipeCardView, direction: CardSwipeDirection)
}

final class StackContainerView: UIView, SwipeCardsDelegate {
    // MARK: - Properties
    var numberOfCardsToShow: Int = 0
    var cardsToBeVisible: Int = 3
    var cardViews: [SwipeCardView] = []
    var remainingCards: Int = 0
    
    let horizontalInset: CGFloat = 8.0
    let verticalInset: CGFloat = 8.0
    
    var visibleCards: [SwipeCardView] {
        return subviews as? [SwipeCardView] ?? []
    }
    
    var dataSource: SwipeCardsDataSource? {
        didSet {
            reloadData()
        }
    }
    
    weak var delegate: StackContainerDelegate?
    private var colors = [UIColor.white, UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1.0), UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1.0)]
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func reloadData() {
        removeAllCardViews()
        guard let datasource = dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()
        numberOfCardsToShow = datasource.numberOfCardsToShow()
        remainingCards = numberOfCardsToShow
        
        for i in 0..<min(numberOfCardsToShow, cardsToBeVisible) {
            let card = datasource.card(at: i)
            card.configureBackgroundColor(color: colors[safe: i])
            addCardView(cardView: card, atIndex: i)
        }
    }
    
    // MARK: - Configurations
    private func addCardView(cardView: SwipeCardView, atIndex index: Int) {
        cardView.delegate = self
        addCardFrame(index: index, cardView: cardView)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingCards -= 1
    }
    
    func addCardFrame(index: Int, cardView: SwipeCardView) {
        var cardViewFrame = bounds
        let horizontalInset = CGFloat(index) * self.horizontalInset
        let verticalInset = CGFloat(index) * self.verticalInset
        
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y -= verticalInset
        
        cardView.frame = cardViewFrame
    }
    
    private func removeAllCardViews() {
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
    
    func swipeDidEnd(on view: SwipeCardView, direction: CardSwipeDirection) {
        guard let datasource = dataSource else { return }
        view.removeFromSuperview()
        
        if remainingCards > 0 {
            let newIndex = datasource.numberOfCardsToShow() - remainingCards
            addCardView(cardView: datasource.card(at: newIndex), atIndex: 2)
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.center
                    cardView.configureBackgroundColor(color: self.colors[safe: cardIndex])
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                })
            }
        } else {
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.center
                    cardView.configureBackgroundColor(color: self.colors[safe: cardIndex])
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                })
            }
        }
        
        delegate?.swipeDidEnd(on: view, direction: direction)
    }
}

