//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 22/03/2024.
//

import Foundation
import Combine
import NetworkingLayer
@testable import SmilesFavourites

final class MyFavouriteServiceHandlerMock: MyFavouritesServiceable {
    // MARK: - Properties
    var favouriteStackListResponse: Result<FavouriteStackListResponse, NetworkError> = .failure(.badURL(""))
    var favouriteVoucherResponse: Result<FavouriteVoucherResponse, NetworkError> = .failure(.badURL(""))
    var favouriteFoodResponse: Result<FavouriteFoodResponse, NetworkError> = .failure(.badURL(""))
    
  
    // MARK: - Mock Behaviours
    func getFavouriteStackListService(request: FavouriteStackListRequest) -> AnyPublisher<FavouriteStackListResponse, NetworkError> {
        Future<FavouriteStackListResponse, NetworkError> { promise in
            promise(self.favouriteStackListResponse)
        }.eraseToAnyPublisher()
    }
    
    func getFavouriteVoucher(request: FavouriteVoucherRequest) -> AnyPublisher<FavouriteVoucherResponse, NetworkError> {
        Future<FavouriteVoucherResponse, NetworkError> { promise in
            promise(self.favouriteVoucherResponse)
        }.eraseToAnyPublisher()
    }
    
    func getFavouriteFood(request: FavouriteFoodRequest) -> AnyPublisher<FavouriteFoodResponse, NetworkError> {
        Future<FavouriteFoodResponse, NetworkError> { promise in
            promise(self.favouriteFoodResponse)
        }.eraseToAnyPublisher()
    }
}
