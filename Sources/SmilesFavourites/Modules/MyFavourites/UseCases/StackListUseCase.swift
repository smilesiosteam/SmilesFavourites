//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 07/03/2024.
//

import Foundation
import Combine

protocol StackListUseCaseProtocol {
    func getStackList(type: StackListType) -> AnyPublisher<StackListUseCase.State, Never>
}

final class StackListUseCase: StackListUseCaseProtocol {
    //MARK: - Properties
    private let repository: MyFavouritesServiceable
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(repository: MyFavouritesServiceable) {
        self.repository = repository
    }
    
    // MARK: - Functions
    func getStackList(type: StackListType) -> AnyPublisher<State, Never> {
        let request = FavouriteStackListRequest(type: type.text)
        
        return Future<State, Never> { [weak self] promise in
            guard let self else { return }
            
            self.repository.getFavouriteStackListService(request: request)
                .sink { completion in
                    if case .failure(let error) = completion {
                        promise(.success(.getStackListDidFail(message: error.localizedDescription)))
                    }
                } receiveValue: { response in
                    promise(.success(.getStackListDidSucceed(response: response)))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
}

extension StackListUseCase {
    enum State: Equatable {
        case getStackListDidFail(message: String)
        case getStackListDidSucceed(response: FavouriteStackListResponse)
    }
}
