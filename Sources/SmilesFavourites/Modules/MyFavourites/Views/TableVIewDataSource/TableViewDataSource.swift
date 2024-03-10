//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 08/03/2024.
//

import Foundation
import SmilesUtilities
import SmilesOffers

extension TableViewDataSource where Model == FavouriteStackListResponse {
    static func make(forStackList stackList: FavouriteStackListResponse, viewModel: FavouritesStackListTableViewCell.ViewModel, reuseIdentifier: String = String(describing: FavouritesStackListTableViewCell.self), data: String, isDummy: Bool = false) -> TableViewDataSource {
        return TableViewDataSource(
            models: [stackList].filter({$0.stackList?.count ?? 0 > 0}),
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (stackCard, cell, data, indexPath) in
            guard let cell = cell as? FavouritesStackListTableViewCell else { return }
            cell.configureCell(with: viewModel)
        }
    }
}
