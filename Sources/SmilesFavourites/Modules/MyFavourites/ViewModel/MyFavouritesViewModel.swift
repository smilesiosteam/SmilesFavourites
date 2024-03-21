//
//  File.swift
//
//
//  Created by Muhammad Shayan Zahid on 07/03/2024.
//

import Foundation
import Combine
import SmilesSharedServices
import SmilesLocationHandler
import CoreLocation
import SmilesOffers
import SmilesUtilities

final class MyFavouritesViewModel {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var statusSubject = PassthroughSubject<State, Never>()
    var statusPublisher: AnyPublisher<State, Never> {
        statusSubject.eraseToAnyPublisher()
    }
    
    private let stackListUseCase: StackListUseCaseProtocol
    private let wishListUseCase: WishListUseCaseProtocol
    private let favouritesVoucherUseCase: FavouriteVoucherUseCase
    private let favouritesFoodUseCase: FavouriteFoodUseCase
    let arraySegments = [SmilesFavouritesLocalization.vouchersTitle.text, SmilesFavouritesLocalization.foodTitle.text]
    var stackListType: StackListType = .voucher
    var pageNumber = 1
    var removeFavouriteData: Any?
    var removeIndexPath: IndexPath?
    var lastRemoveId: String?
    
    // MARK: - Init
    init(useCase: StackListUseCaseProtocol, wishListUseCase: WishListUseCaseProtocol, favouritesVoucherUseCase: FavouriteVoucherUseCase, favouriteFoodUseCase: FavouriteFoodUseCase) {
        self.stackListUseCase = useCase
        self.wishListUseCase = wishListUseCase
        self.favouritesVoucherUseCase = favouritesVoucherUseCase
        self.favouritesFoodUseCase = favouriteFoodUseCase
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
                
                self.getFavourites()
            }
            .store(in: &cancellables)
    }
    
    func getFavourites() {
        if stackListType == .voucher {
            getFavouriteVoucher()
        }
        else {
            getFavouriteFood()
        }
    }
    
    func updateWishList(id: String, operation: Int) {
        lastRemoveId = id
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
    
    func getFavouriteVoucher() {
        LocationManager.shared.getLocation { location, _ in
            //            self.updatedLocation = location
            //            if let _ = location {
            //                CommonMethods.fireEvent(withTag: "location_enabled")
            //            }
            //            else {
            //                CommonMethods.fireEvent(withTag: "location_disabled")
            //            }
            
            self.favouritesVoucherUseCase.getFavouriteVoucher(withCurrentLocation: location, pageNumber: self.pageNumber)
                .sink { [weak self] state in
                    guard let self else { return }
                    
                    switch state {
                    case .getFavouriteVoucherDidFail(let message):
                        self.statusSubject.send(.showError(message: message))
                    case .getFavouriteVoucherDidSucceed(let response):
                        self.statusSubject.send(.favouriteVoucher(response: response))
                    }
                }
                .store(in: &self.cancellables)
        }
    }
    
    func getFavouriteFood() {
        self.favouritesFoodUseCase.getFavouriteFood()
            .sink { [weak self] state in
                guard let self else { return }
                
                switch state {
                case .getFavouriteFoodDidFail(let message):
                    self.statusSubject.send(.showError(message: message))
                case .getFavouriteFoodDidSucceed(let response):
                    self.statusSubject.send(.favouriteFood(response: response))
                }
            }
            .store(in: &self.cancellables)
    }
    
    func undoFavourites() {
        self.removeFavouriteData = nil
        self.removeIndexPath = nil
        self.lastRemoveId = nil
    }
    
    func resetRemoveFavourites() {
        if lastRemoveId == nil {
            self.removeFavouriteData = nil
            self.removeIndexPath = nil
        }
        else {
            if let offerData = self.removeFavouriteData as? OfferDO {
                if offerData.offerId == lastRemoveId {
                    self.undoFavourites()
                }
            }
            else if let foodData = self.removeFavouriteData as? Restaurant {
                if foodData.restaurantId == lastRemoveId {
                    self.undoFavourites()
                }
            }
        }
    }
    
    func removeFromFavourites() {
        if let offerData = self.removeFavouriteData as? OfferDO,
            let offerId = offerData.offerId {
            self.updateWishList(id: offerId, operation: 2)
        }
        else if let foodData = self.removeFavouriteData as? Restaurant,
                let restaurantId = foodData.restaurantId {
            self.updateWishList(id: restaurantId, operation: 2)
        }
    }
}

extension MyFavouritesViewModel {
    enum State {
        case showError(message: String)
        case stackList(response: FavouriteStackListResponse)
        case updateWishList(response: WishListResponseModel)
        case favouriteVoucher(response: FavouriteVoucherResponse)
        case favouriteFood(response: FavouriteFoodResponse)
    }
}
