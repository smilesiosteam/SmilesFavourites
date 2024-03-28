//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 07/03/2024.
//

import UIKit

struct FavouriteStackListResponse: Codable, Equatable {
    // MARK: - Properties
    let stackList: [StackCard]?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case stackList
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stackList = try container.decodeIfPresent([StackCard].self, forKey: .stackList)
    }
    
    init() {
        stackList = []
    }
    
    static func == (lhs: FavouriteStackListResponse, rhs: FavouriteStackListResponse) -> Bool {
        return lhs.stackList?.count == rhs.stackList?.count
    }
}

struct StackCard: Codable {
    // MARK: - Properties
    let stackId: String?
    let stackTitle: String?
    let stackPointsValue: String?
    let stackDirhamValue: String?
    let stackPartnerImage: String?
    let minimumOrder: Double?
    let cuisine: String?
    let restaurantImage: String?
    let deliveryCharges: Double?
    let perPerson: Double?
    let rating: Double?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case stackId
        case stackTitle
        case stackPointsValue
        case stackDirhamValue
        case stackPartnerImage
        case minimumOrder = "minOrder"
        case cuisine
        case restaurantImage
        case deliveryCharges
        case perPerson
        case rating
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stackId = try container.decodeIfPresent(String.self, forKey: .stackId)
        self.stackTitle = try container.decodeIfPresent(String.self, forKey: .stackTitle)
        self.stackPointsValue = try container.decodeIfPresent(String.self, forKey: .stackPointsValue)
        self.stackDirhamValue = try container.decodeIfPresent(String.self, forKey: .stackDirhamValue)
        self.stackPartnerImage = try container.decodeIfPresent(String.self, forKey: .stackPartnerImage)
        self.minimumOrder = try container.decodeIfPresent(Double.self, forKey: .minimumOrder)
        self.cuisine = try container.decodeIfPresent(String.self, forKey: .cuisine)
        self.deliveryCharges = try container.decodeIfPresent(Double.self, forKey: .deliveryCharges)
        self.perPerson = try container.decodeIfPresent(Double.self, forKey: .perPerson)
        self.restaurantImage = try container.decodeIfPresent(String.self, forKey: .restaurantImage)
        self.rating = try container.decodeIfPresent(Double.self, forKey: .rating)
    }
}
