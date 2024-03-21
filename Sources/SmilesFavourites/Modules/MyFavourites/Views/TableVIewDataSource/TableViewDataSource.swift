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

extension TableViewDataSource where Model == OfferDO {
    static func make(forFavouriteVoucher vouchers: [OfferDO], reuseIdentifier: String = String(describing: RestaurantsRevampTableViewCell.self), data: String, isDummy: Bool = false, completion: ((Bool, String, IndexPath?) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: vouchers,
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (voucherData, cell, data, indexPath) in
            guard let cell = cell as? RestaurantsRevampTableViewCell else { return }
            cell.selectionStyle = .none
            cell.offerCellType = .favourite
            cell.restaurantData = nil
            cell.configureCell(with: voucherData)
            cell.favoriteCallback = { isFavorite, offerId in
                completion?(isFavorite, offerId, indexPath)
            }
        }
    }
}

extension TableViewDataSource where Model == Restaurant {
    static func make(forFavouriteFood foods: [Restaurant], reuseIdentifier: String = String(describing: RestaurantsRevampTableViewCell.self), data: String, isDummy: Bool = false, completion: ((Bool, String, IndexPath?) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: foods,
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (foodData, cell, data, indexPath) in
            guard let cell = cell as? RestaurantsRevampTableViewCell else { return }
            cell.selectionStyle = .none
            foodData.isFavoriteRestaurant = true
            cell.offerData = nil
            cell.configureCell(with: foodData)
            cell.favoriteCallback = { isFavorite, restaurantId in
                completion?(isFavorite, restaurantId, indexPath)
            }
        }
    }
}
