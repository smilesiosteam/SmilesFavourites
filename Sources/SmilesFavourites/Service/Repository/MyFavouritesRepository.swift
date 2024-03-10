//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 07/03/2024.
//

import Foundation
import Combine
import NetworkingLayer

protocol MyFavouritesServiceable {
    func getFavouriteStackListService(request: FavouriteStackListRequest) -> AnyPublisher<FavouriteStackListResponse, NetworkError>
}

final class MyFavouritesRepository: MyFavouritesServiceable {
    // MARK: - Properties
    private let networkRequest: Requestable
    
    // MARK: - Init
    init(networkRequest: Requestable) {
        self.networkRequest = networkRequest
    }
  
    // MARK: - Methods
    func getFavouriteStackListService(request: FavouriteStackListRequest) -> AnyPublisher<FavouriteStackListResponse, NetworkError> {
        let endPoint = MyFavouritesRequestBuilder.getFavouriteStackList(request: request)
        let request = endPoint.createRequest(
            endPoint: .favouriteStackList
        )

        return networkRequest.request(request)
    }
}
