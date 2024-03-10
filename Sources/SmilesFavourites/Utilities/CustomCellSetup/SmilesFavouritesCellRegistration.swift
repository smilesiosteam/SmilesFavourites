//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 08/03/2024.
//

import UIKit
import SmilesUtilities
import SmilesOffers

struct SmilesFavouritesCellRegistration: CellRegisterable {
    func register(for tableView: UITableView) {
        tableView.registerCellFromNib(FavouritesStackListTableViewCell.self, bundle: .module)
        tableView.registerCellFromNib(RestaurantsRevampTableViewCell.self, bundle: RestaurantsRevampTableViewCell.module)
    }
}

