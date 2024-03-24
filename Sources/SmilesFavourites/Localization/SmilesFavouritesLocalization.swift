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
    case removedFromFavouritesTitle
    case undoTitle
    case swipeToAddToFavouritesMessage
    case addedToTheListMessage
    case greatJobMessage
    case findYouMoreFavesMessage
    
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
        case .removedFromFavouritesTitle:
            return "RemovedFromFavouritesTitle".localizedString
        case .undoTitle:
            return "UndoTitle".localizedString
        case .swipeToAddToFavouritesMessage:
            return "SwipeToAddToFavouritesMessage".localizedString
        case .addedToTheListMessage:
            return "AddedToTheListMessage".localizedString
        case .greatJobMessage:
            return "GreatJobMessage".localizedString
        case .findYouMoreFavesMessage:
            return "FindYouMoreFavesMessage".localizedString
        }
    }
}
