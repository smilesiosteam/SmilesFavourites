//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 13/03/2024.
//

import Foundation
import Combine
import SmilesSharedServices
import NetworkingLayer
import SmilesUtilities

protocol WishListUseCaseProtocol: AnyObject {
    func updateOfferWishListStatus(offerId: String, operation: Int) -> Future<WishListUseCase.State, Never>
    func updateRestaurantWishListStatus(restaurantId: String, operation: Int) -> Future<WishListUseCase.State, Never>
}

final class WishListUseCase: WishListUseCaseProtocol {
    public var wishListUseCaseInput: PassthroughSubject<WishListViewModel.Input, Never> = .init()
    private let wishListViewModel = WishListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    func updateOfferWishListStatus(offerId: String, operation: Int) -> Future<WishListUseCase.State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else { return }
            
            wishListUseCaseInput = PassthroughSubject<WishListViewModel.Input, Never>()
            let output = wishListViewModel.transform(input: wishListUseCaseInput.eraseToAnyPublisher())
            self.wishListUseCaseInput.send(.updateOfferWishlistStatus(operation: operation, offerId: offerId, baseUrl: AppCommonMethods.serviceBaseUrl))
            output.sink { event in
                switch event {
                case .updateWishlistStatusDidSucceed(let response):
                    promise(.success(.updateWishListStatusDidSucceed(response: response)))
                case .updateWishlistDidFail(let error):
                    promise(.success(.updateWishListDidFail(message: error.localizedDescription)))
                }
            }.store(in: &cancellables)
        }
    }
    
    func updateRestaurantWishListStatus(restaurantId: String, operation: Int) -> Future<WishListUseCase.State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else { return }
            
            wishListUseCaseInput = PassthroughSubject<WishListViewModel.Input, Never>()
            let output = wishListViewModel.transform(input: wishListUseCaseInput.eraseToAnyPublisher())
            self.wishListUseCaseInput.send(.updateRestaurantWishlistStatus(operation: operation, restaurantId: restaurantId, baseUrl: AppCommonMethods.serviceBaseUrl))
            output.sink { event in
                switch event {
                case .updateWishlistStatusDidSucceed(let response):
                    promise(.success(.updateWishListStatusDidSucceed(response: response)))
                case .updateWishlistDidFail(let error):
                    promise(.success(.updateWishListDidFail(message: error.localizedDescription)))
                }
            }.store(in: &cancellables)
        }
    }
}

extension WishListUseCase {
    enum State {
        case updateWishListStatusDidSucceed(response: WishListResponseModel)
        case updateWishListDidFail(message: String)
    }
}
