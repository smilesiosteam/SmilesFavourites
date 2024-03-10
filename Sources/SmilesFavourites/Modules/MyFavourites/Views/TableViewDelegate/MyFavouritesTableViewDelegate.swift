//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 08/03/2024.
//

import UIKit
import SmilesUtilities

final class MyFavouritesTableViewDelegate: NSObject, UITableViewDelegate {
    var sections = [TableSectionData<SmilesFavouritesSectionIdentifier>]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch sections[indexPath.section].identifier {
//        case .stackList:
//            print("Tapped stack list")
//        case .favouritesList:
//            break
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
