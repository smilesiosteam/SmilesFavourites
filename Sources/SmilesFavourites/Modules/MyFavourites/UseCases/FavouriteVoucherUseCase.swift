//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 11/03/2024.
//

import Foundation
import Combine
import CoreLocation

protocol FavouriteVoucherUseCaseProtocol {
    func getFavouriteVoucher(withCurrentLocation: CLLocation?, pageNumber: Int) -> AnyPublisher<FavouriteVoucherUseCase.State, Never>
}

final class FavouriteVoucherUseCase: FavouriteVoucherUseCaseProtocol {
    
    //MARK: - Properties
    private let repository: MyFavouritesServiceable
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(repository: MyFavouritesServiceable) {
        self.repository = repository
    }
    
    // MARK: - Functions
    func getFavouriteVoucher(withCurrentLocation: CLLocation?, pageNumber: Int) -> AnyPublisher<State, Never> {
        let request = FavouriteVoucherRequest()
        request.locationLongitude = withCurrentLocation?.coordinate.longitude ?? 0 > 0 ? withCurrentLocation?.coordinate.longitude ?? 0 : 0
        
        request.locationLatitude = withCurrentLocation?.coordinate.latitude ?? 0 > 0 ? withCurrentLocation?.coordinate.latitude ?? 0 : 0
        
        request.pageNo = Double(pageNumber)
        
        return Future<State, Never> { [weak self] promise in
            guard let self else { return }
            
            self.repository.getFavouriteVoucher(request: request)
                .sink { completion in
                    if case .failure(let error) = completion {
                        promise(.success(.getFavouriteVoucherDidFail(message: error.localizedDescription)))
                    }
                } receiveValue: { response in
                    promise(.success(.getFavouriteVoucherDidSucceed(response: response)))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
}

extension FavouriteVoucherUseCase {
    enum State {
        case getFavouriteVoucherDidFail(message: String)
        case getFavouriteVoucherDidSucceed(response: FavouriteVoucherResponse)
    }
}
