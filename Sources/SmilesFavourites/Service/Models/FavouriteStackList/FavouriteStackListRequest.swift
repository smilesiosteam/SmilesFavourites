//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 07/03/2024.
//

import Foundation
import SmilesBaseMainRequestManager

final class FavouriteStackListRequest: SmilesBaseMainRequest {
    // MARK: - Properties
    let type: String?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case type
    }
    
    // MARK: - Lifecycle
    init(type: String? = nil) {
        self.type = type
        super.init()
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // MARK: - Property Encoder
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.type, forKey: .type)
    }
}

