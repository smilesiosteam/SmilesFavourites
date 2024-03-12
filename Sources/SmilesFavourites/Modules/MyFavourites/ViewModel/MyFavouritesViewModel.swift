//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 07/03/2024.
//

import Foundation
import Combine
import SmilesSharedServices

final class MyFavouritesViewModel {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var statusSubject = PassthroughSubject<State, Never>()
    var statusPublisher: AnyPublisher<State, Never> {
        statusSubject.eraseToAnyPublisher()
    }
    
    private let stackListUseCase: StackListUseCaseProtocol
    private let wishListUseCase: WishListUseCaseProtocol
    let arraySegments = [SmilesFavouritesLocalization.vouchersTitle.text, SmilesFavouritesLocalization.foodTitle.text]
    var stackListType: StackListType = .voucher
    
    // MARK: - Init
    init(stackListUseCase: StackListUseCaseProtocol, wishListUseCase: WishListUseCaseProtocol) {
        self.stackListUseCase = stackListUseCase
        self.wishListUseCase = wishListUseCase
    }
    
    func getStackList(with type: StackListType) {
        stackListUseCase.getStackList(type: type)
            .sink { [weak self] state in
                guard let self else { return }
                
                switch state {
                case .getStackListDidFail(let message):
                    self.statusSubject.send(.showError(message: message))
                case .getStackListDidSucceed(let response):
                    self.statusSubject.send(.stackList(response: response))
                }
            }
        .store(in: &cancellables)
    }
    
    func updateWishList(id: String, operation: Int) {
        if stackListType == .voucher {
            wishListUseCase.updateOfferWishListStatus(offerId: id, operation: operation)
                .sink { [weak self] state in
                    guard let self else { return }
                    
                    switch state {
                    case .updateWishListDidFail(let message):
                        self.statusSubject.send(.showError(message: message))
                    case .updateWishListStatusDidSucceed(let response):
                        self.statusSubject.send(.updateWishList(response: response))
                    }
                }
            .store(in: &cancellables)
        } else {
            wishListUseCase.updateRestaurantWishListStatus(restaurantId: id, operation: operation)
                .sink { [weak self] state in
                    guard let self else { return }
                    
                    switch state {
                    case .updateWishListDidFail(let message):
                        self.statusSubject.send(.showError(message: message))
                    case .updateWishListStatusDidSucceed(let response):
                        self.statusSubject.send(.updateWishList(response: response))
                    }
                }
            .store(in: &cancellables)
        }
    }
}

extension MyFavouritesViewModel {
    enum State {
        case showError(message: String)
        case stackList(response: FavouriteStackListResponse)
        case updateWishList(response: WishListResponseModel)
    }
}
