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
    static func getFavouriteStackListModel(type: StackListType) -> FavouriteStackListResponse {
        if type == .voucher {
            let model: FavouriteStackListResponse? = readJsonFile("StackList_Voucher_Model", bundle: .module)
            return model ?? .init()
        }
        else {
            let model: FavouriteStackListResponse? = readJsonFile("StackList_Food_Model", bundle: .module)
            return model ?? .init()
        }
    }
}
