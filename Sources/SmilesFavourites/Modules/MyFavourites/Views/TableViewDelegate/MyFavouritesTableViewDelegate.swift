//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 08/03/2024.
//

import UIKit
import SmilesUtilities
import Combine

final class MyFavouritesTableViewDelegate: NSObject, UITableViewDelegate {
    var sections = [TableSectionData<SmilesFavouritesSectionIdentifier>]()
    private var statusSubject = PassthroughSubject<State, Never>()
    var statusPublisher: AnyPublisher<State, Never> {
        statusSubject.eraseToAnyPublisher()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].identifier {
        case .swipeMessage:
            debugPrint("Tapped swipe message")
        case .stackList:
            debugPrint("Tapped stack list")
        case .favouritesList:
            statusSubject.send(.didSelectRow(indexPath: indexPath))
            break
        }
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

extension MyFavouritesTableViewDelegate {
    enum State {
        case didSelectRow(indexPath: IndexPath)
    }
}
