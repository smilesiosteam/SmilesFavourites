//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 11/03/2024.
//

import Foundation
import Combine
import SmilesLocationHandler

protocol FavouriteFoodUseCaseProtocol {
    func getFavouriteFood() -> AnyPublisher<FavouriteFoodUseCase.State, Never>
}

final class FavouriteFoodUseCase: FavouriteFoodUseCaseProtocol {
    
    //MARK: - Properties
    private let repository: MyFavouritesServiceable
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(repository: MyFavouritesServiceable) {
        self.repository = repository
    }
    
    // MARK: - Functions
    func getFavouriteFood() -> AnyPublisher<State, Never> {
        let request = FavouriteFoodRequest()
        if let userInfo = LocationStateSaver.getLocationInfo() {
            request.userInfo = userInfo
        }
        
        return Future<State, Never> { [weak self] promise in
            guard let self else { return }
            
            self.repository.getFavouriteFood(request: request)
                .sink { completion in
                    if case .failure(let error) = completion {
                        promise(.success(.getFavouriteFoodDidFail(message: error.localizedDescription)))
                    }
                } receiveValue: { response in
                    promise(.success(.getFavouriteFoodDidSucceed(response: response)))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
}

extension FavouriteFoodUseCase {
    enum State: Equatable {
        case getFavouriteFoodDidFail(message: String)
        case getFavouriteFoodDidSucceed(response: FavouriteFoodResponse)
    }
}
