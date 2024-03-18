//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 11/03/2024.
//

import Foundation
import SmilesUtilities
import SmilesBaseMainRequestManager

class FavouriteFoodRequest: SmilesBaseMainRequest {
    
    override init() {
        super.init()
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func asDictionary(dictionary: [String: Any]) -> [String: Any] {
        let encoder = DictionaryEncoder()
        guard let encoded = try? encoder.encode(self) as [String: Any] else {
            return [:]
        }
        return encoded.mergeDictionaries(dictionary: dictionary)
    }
}
