//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 22/03/2024.
//

import Foundation
import Combine
import CoreLocation
@testable import SmilesFavourites

final class FavouriteVoucherUseCaseMock: FavouriteVoucherUseCaseProtocol {
    var favouriteVoucherUseCaseResponse: Result<FavouriteVoucherUseCase.State, Never> = .success(.getFavouriteVoucherDidFail(message: ""))
    
    func getFavouriteVoucher(withCurrentLocation: CLLocation?, pageNumber: Int) -> AnyPublisher<FavouriteVoucherUseCase.State, Never> {
        Future<FavouriteVoucherUseCase.State, Never> { promise in
            promise(self.favouriteVoucherUseCaseResponse)
        }.eraseToAnyPublisher()
    }
}
