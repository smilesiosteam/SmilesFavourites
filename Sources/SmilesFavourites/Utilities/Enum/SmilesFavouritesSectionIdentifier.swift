//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 08/03/2024.
//

import Foundation
import SmilesUtilities

enum SmilesFavouritesSectionIdentifier: String, SectionIdentifierProtocol {
    var identifier: String { return self.rawValue }
    
    case swipeMessage
    case stackList
    case favouritesList
}

struct SmilesFavouritesSectionData {
    let index: Int
    let identifier: SmilesFavouritesSectionIdentifier
}
