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
    func getFavouriteVoucher(request: FavouriteVoucherRequest) -> AnyPublisher<FavouriteVoucherResponse, NetworkError>
    func getFavouriteFood(request: FavouriteFoodRequest) -> AnyPublisher<FavouriteFoodResponse, NetworkError>
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
    
    func getFavouriteVoucher(request: FavouriteVoucherRequest) -> AnyPublisher<FavouriteVoucherResponse, NetworkError> {
        let endPoint = MyFavouritesRequestBuilder.getFavourtieVoucher(request: request)
        let request = endPoint.createRequest(
            endPoint: .getFavourtieVoucher
        )

        return networkRequest.request(request)
    }
    
    func getFavouriteFood(request: FavouriteFoodRequest) -> AnyPublisher<FavouriteFoodResponse, NetworkError> {
        let endPoint = MyFavouritesRequestBuilder.getFavouriteFood(request: request)
        let request = endPoint.createRequest(
            endPoint: .getFavouriteRestaurantsEndPoint
        )

        return networkRequest.request(request)
    }
}
