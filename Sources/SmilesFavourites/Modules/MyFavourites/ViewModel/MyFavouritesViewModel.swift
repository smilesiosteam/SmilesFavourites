//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 07/03/2024.
//

import Foundation
import Combine


final class MyFavouritesViewModel {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var statusSubject = PassthroughSubject<State, Never>()
    var statusPublisher: AnyPublisher<State, Never> {
        statusSubject.eraseToAnyPublisher()
    }
    
    private let stackListUseCase: StackListUseCaseProtocol
    let arraySegments = [SmilesFavouritesLocalization.vouchersTitle.text, SmilesFavouritesLocalization.foodTitle.text]
    var stackListType: StackListType = .voucher
    
    // MARK: - Init
    init(useCase: StackListUseCaseProtocol) {
        self.stackListUseCase = useCase
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
}

extension MyFavouritesViewModel {
    enum State {
        case showError(message: String)
        case stackList(response: FavouriteStackListResponse)
    }
}
