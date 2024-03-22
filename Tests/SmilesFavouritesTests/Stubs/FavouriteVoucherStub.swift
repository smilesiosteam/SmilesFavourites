//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 22/03/2024.
//

import Foundation
import SmilesTests
@testable import SmilesFavourites

enum FavouriteVoucherStub {
    static var getFavouriteVoucherModel: FavouriteVoucherResponse {
        let model: FavouriteVoucherResponse? = readJsonFile("Order_Tracking_Model", bundle: .module)
        return model ?? .init()
    }
}
