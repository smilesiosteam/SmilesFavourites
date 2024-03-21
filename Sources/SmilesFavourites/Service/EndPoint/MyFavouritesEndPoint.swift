//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 07/03/2024.
//

import Foundation

enum MyFavouritesEndPoint {
    case favouriteStackList
    case getFavouriteVoucher
    case getFavouriteRestaurantsEndPoint
    
    var url: String {
        switch self {
        case .favouriteStackList:
            return "home/get-favorite-stack-list"
        case .getFavouriteVoucher:
            return "home/get-wishlist"
        case .getFavouriteRestaurantsEndPoint:
            return "user/v1/get-favorite-restaurant"
        }
    }
}
