//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 07/03/2024.
//

import Foundation

enum StackListType: Int {
    case voucher
    case food
    
    var text: String {
        switch self {
        case .voucher:
            return "voucher"
        case .food:
            return "food"
        }
    }
}
