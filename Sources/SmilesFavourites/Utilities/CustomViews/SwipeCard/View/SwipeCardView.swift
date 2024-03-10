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
    private let pointsStackView = UIStackView()
    private let pointsImageView = UIImageView()
    private let pointsTextStackView = UIStackView()
    private let pointsTextStackContainerView = UIView()
    private let pointsLabel = UILabel()
    private let orLabel = UILabel()
    private let aedLabel = UILabel()
    
    var delegate: SwipeCardsDelegate?
    
    var divisor: CGFloat = 0
    
    var dataSource: StackCard? {
        didSet {
            titleLabel.text = dataSource?.stackTitle
            pointsImageView.image = UIImage(resource: .smileyIcon)
            pointsLabel.text = "\(dataSource?.stackPointsValue ?? "0") \(SmilesFavouritesLocalization.pointsTitle.text)"
            orLabel.text = SmilesFavouritesLocalization.orTitle.text
            aedLabel.text = "\(dataSource?.stackDirhamValue ?? "0") \(SmilesFavouritesLocalization.aed.text)"
            imageView.setImageWithUrlString(dataSource?.stackPartnerImage ?? "")
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureSwipeView()
        configureImageView()
        configureTitleLabelView()
        configureSubtitleLabelView()
        configurePointsImageView()
        configurePointsLabelView()
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
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor)
        ])
    }
    
    private func configureSubtitleLabelView() {
        subtitleLabel.textColor = .black
        subtitleLabel.textAlignment = .natural
        subtitleLabel.fontTextStyle = .smilesBody3
        subtitleLabel.numberOfLines = 1
    }
    
    private func configureTitleStackView() {
        swipeView.addSubview(titleStackView)
        titleStackView.axis = .vertical
        titleStackView.alignment = .fill
        titleStackView.distribution = .fill
        titleStackView.spacing = 4
        [titleContainerView, subtitleLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: swipeView.topAnchor, constant: 16),
            titleStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            titleStackView.trailingAnchor.constraint(equalTo: swipeView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configurePointsImageView() {
        pointsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pointsImageView.widthAnchor.constraint(equalToConstant: 24),
            pointsImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
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
        [pointsImageView, pointsTextStackContainerView].forEach {
            pointsStackView.addArrangedSubview($0)
        }
        
        pointsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pointsStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            pointsStackView.trailingAnchor.constraint(equalTo: swipeView.trailingAnchor, constant: -16),
            pointsStackView.bottomAnchor.constraint(equalTo: swipeView.bottomAnchor, constant: -16)
        ])
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
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            } else if card.center.x < -65 {
                delegate?.swipeDidEnd(on: card)
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
