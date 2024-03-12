//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 13/03/2024.
//

import Foundation

enum CardSwipeDirection {
    case right
    case left
    
    var operation: Int {
        switch self {
        case .right:
            return 1
        case .left:
            return 3
        }
    }
}
