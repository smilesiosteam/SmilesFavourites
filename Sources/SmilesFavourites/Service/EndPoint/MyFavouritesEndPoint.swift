//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 07/03/2024.
//

import Foundation

enum MyFavouritesEndPoint {
    case favouriteStackList
    
    var url: String {
        switch self {
        case .favouriteStackList:
            return "home/get-favorite-stack-list"
        }
    }
}
