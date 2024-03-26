//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 11/03/2024.
//

import Foundation
import NetworkingLayer
import SmilesUtilities
import SmilesOffers

class FavouriteFoodResponse: BaseMainResponse, Equatable {
    var restaurants: [Restaurant]?
    
    enum CodingKeys: String, CodingKey {
        case restaurants
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        restaurants = try values.decodeIfPresent([Restaurant].self, forKey: .restaurants)

        try super.init(from: decoder)
    }
    
    override init() {
        super.init()
    }
    
    static func == (lhs: FavouriteFoodResponse, rhs: FavouriteFoodResponse) -> Bool {
        return lhs.restaurants?.count == rhs.restaurants?.count
    }
}
