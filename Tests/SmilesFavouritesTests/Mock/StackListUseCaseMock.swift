//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 28/03/2024.
//

import Foundation
import Combine
import CoreLocation
@testable import SmilesFavourites

final class StackListUseCaseMock: StackListUseCaseProtocol {
    var stackListUseCaseResponse: Result<StackListUseCase.State, Never> = .success(.getStackListDidFail(message: ""))
    
    func getStackList(type: StackListType) -> AnyPublisher<StackListUseCase.State, Never> {
        Future<StackListUseCase.State, Never> { promise in
            promise(self.stackListUseCaseResponse)
        }.eraseToAnyPublisher()
    }
}
