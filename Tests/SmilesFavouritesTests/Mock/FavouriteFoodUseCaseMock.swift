//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 25/03/2024.
//

import Foundation
import Combine
import CoreLocation
@testable import SmilesFavourites

final class FavouriteFoodUseCaseMock: FavouriteFoodUseCaseProtocol {
    var favouriteFoodUseCaseResponse: Result<FavouriteFoodUseCase.State, Never> = .success(.getFavouriteFoodDidFail(message: ""))
    
    func getFavouriteFood() -> AnyPublisher<FavouriteFoodUseCase.State, Never> {
        Future<FavouriteFoodUseCase.State, Never> { promise in
            promise(self.favouriteFoodUseCaseResponse)
        }.eraseToAnyPublisher()
    }
}
