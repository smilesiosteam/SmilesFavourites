//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 25/03/2024.
//

import Foundation
import SmilesTests
@testable import SmilesFavourites

enum FavouriteFoodStub {
    static var getFavouriteFoodModel: FavouriteFoodResponse {
        let model: FavouriteFoodResponse? = readJsonFile("Favourite_Food_Model", bundle: .module)
        return model ?? .init()
    }
}
