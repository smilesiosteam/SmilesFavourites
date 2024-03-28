//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 08/03/2024.
//

import UIKit
import Combine
import SmilesLocationHandler

final class SegmentsCollectionViewDataSource: NSObject {
    // MARK: - Properties
    private let arraySegments: [String]
    private var statusSubject = PassthroughSubject<State, Never>()
    private var selectedIndex = 0
    var statusPublisher: AnyPublisher<State, Never> {
        statusSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(arraySegments: [String]) {
        self.arraySegments = arraySegments
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension SegmentsCollectionViewDataSource: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraySegments.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MyFavoritesSegmentCollectionViewCell.self), for: indexPath) as? MyFavoritesSegmentCollectionViewCell else { return UICollectionViewCell() }
        
        let viewModel = MyFavoritesSegmentCollectionViewCell.ViewModel(title: arraySegments[indexPath.item], isSelected: selectedIndex == indexPath.item)
        cell.configureCell(with: viewModel)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        statusSubject.send(.didSelectItem(index: selectedIndex))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = arraySegments[indexPath.item]
        let textAttributes = [NSAttributedString.Key.font: UIFont.circularXXTTMediumFont(size: 16.0)]
        let attributedText = NSAttributedString(string: text, attributes: textAttributes as [NSAttributedString.Key : Any])
        let textSize = attributedText.size()
        return CGSize(width: textSize.width + 6, height: 40)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
}

// MARK: - State
extension SegmentsCollectionViewDataSource {
    enum State {
        case didSelectItem(index: Int)
    }
}
