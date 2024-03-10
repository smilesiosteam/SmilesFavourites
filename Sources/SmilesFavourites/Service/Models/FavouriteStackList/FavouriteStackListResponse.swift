//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 07/03/2024.
//

import UIKit

struct FavouriteStackListResponse: Codable {
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
}

struct StackCard: Codable {
    // MARK: - Properties
    let stackId: String?
    let stackTitle: String?
    let stackPointsValue: String?
    let stackDirhamValue: String?
    let stackPartnerImage: String?
    var backgroundColor: UIColor?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case stackId
        case stackTitle
        case stackPointsValue
        case stackDirhamValue
        case stackPartnerImage
    }
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stackId = try container.decodeIfPresent(String.self, forKey: .stackId)
        self.stackTitle = try container.decodeIfPresent(String.self, forKey: .stackTitle)
        self.stackPointsValue = try container.decodeIfPresent(String.self, forKey: .stackPointsValue)
        self.stackDirhamValue = try container.decodeIfPresent(String.self, forKey: .stackDirhamValue)
        self.stackPartnerImage = try container.decodeIfPresent(String.self, forKey: .stackPartnerImage)
    }
}
