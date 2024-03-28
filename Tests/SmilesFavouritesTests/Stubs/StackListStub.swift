//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 28/03/2024.
//

import Foundation
import SmilesTests
@testable import SmilesFavourites

enum StackListStub {
    static var getFavouriteStackListFoodModel: FavouriteStackListResponse {
        let model: FavouriteStackListResponse? = readJsonFile("StackList_Food_Model", bundle: .module)
        return model ?? .init()
    }
    
    static var getFavouriteStackListVoucherModel: FavouriteStackListResponse {
        let model: FavouriteStackListResponse? = readJsonFile("StackList_Voucher_Model", bundle: .module)
        return model ?? .init()
    }
}
