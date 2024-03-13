//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 07/03/2024.
//

import Foundation
import SmilesUtilities

enum SmilesFavouritesLocalization {
    case vouchersTitle
    case foodTitle
    case favouriteListEmptyMessage
    case swipeStackListMessage
    case aed
    case pointsTitle
    case orTitle
    case minimumOrderTitle
    case deliveryChargesTitle
    case freeDeliveryTitle
    case favourites
    
    var text: String {
        switch self {
        case .vouchersTitle:
            return "VouchersHeading".localizedString
        case .foodTitle:
            return "FoodHeading".localizedString
        case .favouriteListEmptyMessage:
            return "FavouriteListEmptyMessage".localizedString
        case .swipeStackListMessage:
            return "SwipeStackListMessage".localizedString
        case .aed:
            return "AED".localizedString
        case .pointsTitle:
            return "PTSTitle".localizedString
        case .orTitle:
            return "or".localizedString
        case .minimumOrderTitle:
            return "RestaurantMinOrder".localizedString
        case .deliveryChargesTitle:
            return "DeliveryCharges".localizedString
        case .freeDeliveryTitle:
            return "FreeDeliveryText".localizedString
        case .favourites:
            return "Favourites".localizedString
        }
    }
}
