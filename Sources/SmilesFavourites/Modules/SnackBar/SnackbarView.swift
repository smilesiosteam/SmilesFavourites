//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 18/03/2024.
//

import Foundation
import UIKit
import SmilesFontsManager

class SnackbarView: UIView {
    
    // MARK: - Properties
    private let messageLabel = UILabel()
    private let actionButton = UIButton()
    private let stackView = UIStackView()
    
    var completion: (() -> Void)?
    
    var actionHandler: (() -> Void)?
    
    // MARK: - Init
    public init(message: String, actionTitle: String? = nil) {
        super.init(frame: CGRect.zero)
        
        messageLabel.text = message
        
        if let title = actionTitle {
            actionButton.setTitle(title, for: .normal)
            actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
            configureActionButton()
        }
        
        configureView()
        configureMessageLabel()
        configureStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func configureView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(actionButton)
    }
    
    private func configureActionButton() {
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.backgroundColor = .clear
        actionButton.fontTextStyle = .smilesTitle1
    }
    
    private func configureMessageLabel() {
        messageLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        messageLabel.fontTextStyle = .smilesTitle2
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func actionButtonTapped() {
        self.completion = nil
        self.removeFromSuperview()
        actionHandler?()
    }
    
    func show(in view: UIView, duration: TimeInterval = 5.0, height: CGFloat = 50.0) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalConstraint = self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0)
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.heightAnchor.constraint(equalToConstant: height),
            self.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 12),
            self.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 12),
            verticalConstraint
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.removeFromSuperview()
            self.completion?()
        }
    }
}
