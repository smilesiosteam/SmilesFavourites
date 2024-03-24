//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 23/03/2024.
//

import Foundation

enum SwipeMessageState {
    case favouritesListEmpty
    case swipeToAddToFavouritesWithoutSwipe
    case swipeToAddToFavouritesWithSwipe
    case greatJob
    
    var state: (title: String, message: String, icon: String) {
        switch self {
        case .favouritesListEmpty:
            return (title: SmilesFavouritesLocalization.favouriteListEmptyMessage.text, message: SmilesFavouritesLocalization.swipeStackListMessage.text, icon: "favourites_empty_icon")
        case .swipeToAddToFavouritesWithoutSwipe:
            return (title: SmilesFavouritesLocalization.swipeToAddToFavouritesMessage.text, message: SmilesFavouritesLocalization.swipeStackListMessage.text, icon: "favourites_empty_icon")
        case .swipeToAddToFavouritesWithSwipe:
            return (title: SmilesFavouritesLocalization.swipeToAddToFavouritesMessage.text, message: SmilesFavouritesLocalization.addedToTheListMessage.text, icon: "favourites_empty_icon")
        case .greatJob:
            return (title: SmilesFavouritesLocalization.greatJobMessage.text, message: SmilesFavouritesLocalization.findYouMoreFavesMessage.text, icon: "clap_icon")
        }
    }
}
