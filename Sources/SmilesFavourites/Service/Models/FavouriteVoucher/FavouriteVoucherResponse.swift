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

class FavouriteVoucherResponse: BaseMainResponse {
    
    var featuredOffers: [OfferDO]?
    var offers: [OfferDO]?
    var lifestyleSubscriberFlag: Bool?
    var offersCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case featuredOffers
        case offers
        case lifestyleSubscriberFlag
        case offersCount
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        featuredOffers = try values.decodeIfPresent([OfferDO].self, forKey: .featuredOffers)
        offers = try values.decodeIfPresent([OfferDO].self, forKey: .offers)
        lifestyleSubscriberFlag = try values.decodeIfPresent(Bool.self, forKey: .lifestyleSubscriberFlag)
        offersCount = try values.decodeIfPresent(Int.self, forKey: .offersCount)
        
        try super.init(from: decoder)
    }
}
