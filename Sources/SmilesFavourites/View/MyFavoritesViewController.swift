//
//  MyFavoritesViewController.swift
//  House
//
//  Created by Hafiz Muhammad Junaid on 05/03/2024.
//  Copyright © 2024 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

public class MyFavoritesViewController: UIViewController {

    @IBOutlet weak var segmentsCollectionView: UICollectionView!
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var bottomBorder: UIView!
    
    let arraySegments = ["VouchersHeading".localizedString, "Food"]
    var selectedIndex = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentsCollectionView.dataSource = self
        segmentsCollectionView.delegate = self
        
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        
        segmentsCollectionView.register(nib: UINib(nibName: "MyFavoritesSegmentCell", bundle: nil), forCellWithClass: MyFavoritesSegmentCell.self)
        
        favoritesTableView.register(UINib(nibName: "MyFavoritesHeaderCell", bundle: nil), forCellReuseIdentifier: "MyFavoritesHeaderCell")
        
        bottomBorder.backgroundColor = .disabledColor
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MyFavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraySegments.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFavoritesSegmentCell", for: indexPath) as! MyFavoritesSegmentCell
        cell.nameLabel.text = arraySegments[indexPath.item]
        if selectedIndex == indexPath.item {
            cell.selectedState()
        }
        else {
            cell.deslectedState()
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = arraySegments[indexPath.item]
        let textAttributes = [NSAttributedString.Key.font: UIFont(name: "CircularXXTT-Medium", size: 16)]
        let attributedText = NSAttributedString(string: text, attributes: textAttributes as [NSAttributedString.Key : Any])
        let textSize = attributedText.size()
        return CGSize(width: textSize.width + 6, height: 40)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MyFavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFavoritesEmptyCell")!
        return cell
    }
}

// MARK: - Create
extension MyFavoritesViewController {
    static public func create() -> MyFavoritesViewController {
        let viewController = MyFavoritesViewController(nibName: String(describing: MyFavoritesViewController.self), bundle: .module)
        return viewController
    }
}
