//
//  SwipeCardView.swift
//  TinderStack
//
//  Created by Osama Naeem on 16/03/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import UIKit
import SmilesFontsManager

final class SwipeCardView : UIView {
    // MARK: - Properties
    private let swipeView = UIView()
    private let imageView = UIImageView()
    private let titleStackView = UIStackView()
    private let titleContainerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let minimumOrderLabel = UILabel()
    private let minimumOrderTitleLabel = UILabel()
    private let pipeSegregationLabel = UILabel()
    private let deliveryChargesLabel = UILabel()
    private let deliveryChargesTitleLabel = UILabel()
    private let minimumOrderStackView = UIStackView()
    private let pointsStackView = UIStackView()
    private let pointsImageView = UIImageView()
    private let ratingLabel = UILabel()
    private let pointsTextStackView = UIStackView()
    private let pointsTextStackContainerView = UIView()
    private let pointsLabel = UILabel()
    private let orLabel = UILabel()
    private let aedLabel = UILabel()
    
    private var cardType: StackListType = .voucher
    var delegate: SwipeCardsDelegate?
    var divisor: CGFloat = 0
    var dataSource: StackCard? {
        didSet {
            if cardType == .voucher {
                setupVoucherCard()
            } else {
                setupFoodCard()
            }
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureSwipeView()
        configureImageView()
        configureTitleLabelView()
        configureSubtitleLabelView()
        configureMinimumOrderLabelView()
        configureMinimumOrderTitleLabelView()
        configurePipeSegregationLabelView()
        configureDeliveryChargesLabelView()
        configureDeliveryChargesTitleLabelView()
        configureMinimumOrderStackView()
        configurePointsImageView()
        configurePointsLabelView()
        configureRatingLabel()
        configureOrLabelView()
        configureAEDLabelView()
        configurePointsTextStackView()
        configurePointsStackView()
        configureTitleStackView()
        addPanGestureOnCards()
        configureTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    private func configureSwipeView() {
        swipeView.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: 12)
        swipeView.addBorder(withBorderWidth: 1, borderColor: .black.withAlphaComponent(0.1))
        addSubview(swipeView)
        swipeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            swipeView.leftAnchor.constraint(equalTo: leftAnchor),
            swipeView.rightAnchor.constraint(equalTo: rightAnchor),
            swipeView.bottomAnchor.constraint(equalTo: bottomAnchor),
            swipeView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    func configureBackgroundColor(color: UIColor?) {
        if let color {
            swipeView.backgroundColor = color
        }
    }
    
    func configureCardType(type: StackListType?) {
        if let type = type {
            cardType = type
        }
    }
    
    private func configureImageView() {
        swipeView.addSubview(imageView)
        
        imageView.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: 8)
        imageView.addBorder(withBorderWidth: 1, borderColor: .black.withAlphaComponent(0.1))
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: swipeView.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: swipeView.leadingAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: swipeView.bottomAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func configureTitleLabelView() {
        titleContainerView.addSubview(titleLabel)
        
        titleLabel.textColor = .black
        titleLabel.textAlignment = .natural
        titleLabel.fontTextStyle = .smilesHeadline3
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: titleContainerView.bottomAnchor)
        ])
    }
    
    private func configureSubtitleLabelView() {
        subtitleLabel.textColor = .black
        subtitleLabel.textAlignment = .natural
        subtitleLabel.fontTextStyle = .smilesBody3
        subtitleLabel.numberOfLines = 2
    }
    
    private func configureMinimumOrderLabelView() {
        minimumOrderLabel.textColor = .black.withAlphaComponent(0.8)
        minimumOrderLabel.textAlignment = .natural
        minimumOrderLabel.fontTextStyle = .smilesTitle3
        minimumOrderLabel.numberOfLines = 1
    }
    
    private func configureMinimumOrderTitleLabelView() {
        minimumOrderTitleLabel.textColor = .black.withAlphaComponent(0.6)
        minimumOrderTitleLabel.textAlignment = .natural
        minimumOrderTitleLabel.fontTextStyle = .smilesBody4
        minimumOrderTitleLabel.numberOfLines = 1
    }
    
    private func configurePipeSegregationLabelView() {
        pipeSegregationLabel.textColor = .black.withAlphaComponent(0.6)
        pipeSegregationLabel.textAlignment = .natural
        pipeSegregationLabel.fontTextStyle = .smilesBody4
        pipeSegregationLabel.numberOfLines = 1
    }
    
    private func configureDeliveryChargesLabelView() {
        deliveryChargesLabel.textColor = .black.withAlphaComponent(0.8)
        deliveryChargesLabel.textAlignment = .natural
        deliveryChargesLabel.fontTextStyle = .smilesTitle3
        deliveryChargesLabel.numberOfLines = 1
    }
    
    private func configureDeliveryChargesTitleLabelView() {
        deliveryChargesTitleLabel.textColor = .black.withAlphaComponent(0.6)
        deliveryChargesTitleLabel.textAlignment = .natural
        deliveryChargesTitleLabel.fontTextStyle = .smilesBody3
        deliveryChargesTitleLabel.numberOfLines = 1
        deliveryChargesTitleLabel.lineBreakMode = .byTruncatingTail
    }
    
    private func configureMinimumOrderStackView() {
        minimumOrderStackView.axis = .horizontal
        minimumOrderStackView.alignment = .fill
        minimumOrderStackView.distribution = .fill
        minimumOrderStackView.spacing = 4
        
        [minimumOrderLabel, minimumOrderTitleLabel, pipeSegregationLabel, deliveryChargesLabel, deliveryChargesTitleLabel].forEach {
            minimumOrderStackView.addArrangedSubview($0)
        }
    }
    
    private func configureTitleStackView() {
        swipeView.addSubview(titleStackView)
        titleStackView.axis = .vertical
        titleStackView.alignment = .fill
        titleStackView.distribution = .fill
        titleStackView.spacing = 4
        [titleContainerView, subtitleLabel, minimumOrderStackView].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: swipeView.topAnchor, constant: 16),
            titleStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            titleStackView.trailingAnchor.constraint(equalTo: swipeView.trailingAnchor, constant: -8),
            titleStackView.bottomAnchor.constraint(equalTo: pointsStackView.topAnchor)
        ])
    }
    
    private func configurePointsImageView() {
        pointsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pointsImageView.widthAnchor.constraint(equalToConstant: 24),
            pointsImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func configureRatingLabel() {
        ratingLabel.textColor = .black.withAlphaComponent(0.8)
        ratingLabel.textAlignment = .natural
        ratingLabel.fontTextStyle = .smilesHeadline5
        ratingLabel.numberOfLines = 1
    }
    
    private func configurePointsLabelView() {
        pointsLabel.textColor = .black.withAlphaComponent(0.8)
        pointsLabel.textAlignment = .natural
        pointsLabel.fontTextStyle = .smilesHeadline5
        pointsLabel.numberOfLines = 1
    }
    
    private func configureOrLabelView() {
        orLabel.textColor = .black.withAlphaComponent(0.6)
        orLabel.textAlignment = .natural
        orLabel.fontTextStyle = .smilesBody3
        orLabel.numberOfLines = 1
    }
    
    private func configureAEDLabelView() {
        aedLabel.textColor = .black.withAlphaComponent(0.8)
        aedLabel.textAlignment = .natural
        aedLabel.fontTextStyle = .smilesHeadline5
        aedLabel.numberOfLines = 1
        aedLabel.lineBreakMode = .byTruncatingTail
    }
    
    private func configurePointsTextStackView() {
        pointsTextStackContainerView.addSubview(pointsTextStackView)
        
        pointsTextStackView.axis = .horizontal
        pointsTextStackView.alignment = .fill
        pointsTextStackView.distribution = .fill
        pointsTextStackView.spacing = 8
        [pointsLabel, orLabel, aedLabel].forEach {
            pointsTextStackView.addArrangedSubview($0)
        }
        
        pointsTextStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pointsTextStackView.topAnchor.constraint(equalTo: pointsTextStackContainerView.topAnchor),
            pointsTextStackView.leadingAnchor.constraint(equalTo: pointsTextStackContainerView.leadingAnchor),
            pointsTextStackView.bottomAnchor.constraint(equalTo: pointsTextStackContainerView.bottomAnchor),
            pointsTextStackView.trailingAnchor.constraint(lessThanOrEqualTo: pointsTextStackContainerView.trailingAnchor)
        ])
    }
    
    private func configurePointsStackView() {
        swipeView.addSubview(pointsStackView)
        
        pointsStackView.axis = .horizontal
        pointsStackView.alignment = .fill
        pointsStackView.distribution = .fill
        pointsStackView.spacing = 4
        [pointsImageView, ratingLabel, pointsTextStackContainerView].forEach {
            pointsStackView.addArrangedSubview($0)
        }
        
        pointsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pointsStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            pointsStackView.trailingAnchor.constraint(equalTo: swipeView.trailingAnchor, constant: -16),
            pointsStackView.bottomAnchor.constraint(equalTo: swipeView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupVoucherCard() {
        titleLabel.text = dataSource?.stackTitle
        pointsImageView.image = UIImage(resource: .smileyIcon)
        pointsLabel.text = "\(dataSource?.stackPointsValue ?? "0") \(SmilesFavouritesLocalization.pointsTitle.text)"
        orLabel.text = SmilesFavouritesLocalization.orTitle.text
        aedLabel.text = "\(dataSource?.stackDirhamValue ?? "0") \(SmilesFavouritesLocalization.aed.text)"
        imageView.setImageWithUrlString(dataSource?.stackPartnerImage ?? "")
    }
    
    private func setupFoodCard() {
        titleLabel.text = dataSource?.stackTitle
        subtitleLabel.text = dataSource?.cuisine
        if let rating = dataSource?.rating, rating > 0 {
            pointsImageView.isHidden = false
            ratingLabel.isHidden = false
            pointsImageView.image = UIImage(resource: .starIcon)
            let ratingText = String(format: "%.1f", rating)
            ratingLabel.text = ratingText
        } else {
            pointsImageView.isHidden = true
            ratingLabel.isHidden = true
        }
        
        imageView.setImageWithUrlString(dataSource?.restaurantImage ?? "")
        
//        if let minimumOrder = dataSource?.minimumOrder, (Double(minimumOrder) ?? 0) > 0, let deliveryCharges = dataSource?.deliveryCharges, deliveryCharges > 0 {
//            
//            minimumOrderLabel.isHidden = false
//            minimumOrderTitleLabel.isHidden = false
//            pipeSegregationLabel.isHidden = false
//            deliveryChargesLabel.isHidden = false
//            deliveryChargesTitleLabel.isHidden = false
//            
//            minimumOrderLabel.text = "\(minimumOrder) \(SmilesFavouritesLocalization.aed.text)"
//            minimumOrderTitleLabel.text = SmilesFavouritesLocalization.minimumOrderTitle.text
//            
//            pipeSegregationLabel.text = "|"
//            
//            deliveryChargesLabel.text = "\(deliveryCharges) \(SmilesFavouritesLocalization.aed.text)"
//            deliveryChargesTitleLabel.text = SmilesFavouritesLocalization.deliveryChargesTitle.text
//        } else if let minimumOrder = dataSource?.minimumOrder, (Double(minimumOrder) ?? 0) > 0 {
//            
//            minimumOrderLabel.isHidden = false
//            minimumOrderTitleLabel.isHidden = false
//            pipeSegregationLabel.isHidden = false
//            deliveryChargesLabel.isHidden = true
//            deliveryChargesTitleLabel.isHidden = false
//            
//            minimumOrderLabel.text = "\(minimumOrder) \(SmilesFavouritesLocalization.aed.text)"
//            minimumOrderTitleLabel.text = SmilesFavouritesLocalization.minimumOrderTitle.text
//            
//            pipeSegregationLabel.text = "|"
//            
//            deliveryChargesTitleLabel.text = SmilesFavouritesLocalization.freeDeliveryTitle.text
//        } else if let deliveryCharges = dataSource?.deliveryCharges, deliveryCharges > 0 {
//            
//            minimumOrderLabel.isHidden = true
//            minimumOrderTitleLabel.isHidden = false
//            pipeSegregationLabel.isHidden = false
//            deliveryChargesLabel.isHidden = false
//            deliveryChargesTitleLabel.isHidden = false
//            
//            minimumOrderTitleLabel.text = SmilesFavouritesLocalization.freeDeliveryTitle.text
//            
//            pipeSegregationLabel.text = "|"
//            
//            deliveryChargesLabel.text = "\(deliveryCharges) \(SmilesFavouritesLocalization.aed.text)"
//            deliveryChargesTitleLabel.text = SmilesFavouritesLocalization.deliveryChargesTitle.text
//        } else {
//            
//            minimumOrderLabel.isHidden = true
//            minimumOrderTitleLabel.isHidden = false
//            pipeSegregationLabel.isHidden = true
//            deliveryChargesLabel.isHidden = true
//            deliveryChargesTitleLabel.isHidden = true
//            
//            minimumOrderTitleLabel.text = SmilesFavouritesLocalization.freeDeliveryTitle.text
//        }
    }
    
    private func configureTapGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    private func addPanGestureOnCards() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    //MARK: - Handlers
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        let card = sender.view as! SwipeCardView
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        
        divisor = ((UIScreen.main.bounds.width / 2) / 0.61)
        
        switch sender.state {
        case .ended:
            if (card.center.x) > 400 {
                delegate?.swipeDidEnd(on: card, direction: .right)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            } else if card.center.x < -65 {
                delegate?.swipeDidEnd(on: card, direction: .left)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }
            
            UIView.animate(withDuration: 0.2) {
                card.transform = .identity
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                self.layoutIfNeeded()
            }
            
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
            
        default:
            break
        }
    }
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer) {}
}
