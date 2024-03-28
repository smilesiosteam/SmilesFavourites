//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 25/03/2024.
//

import XCTest
import SmilesTests
@testable import SmilesFavourites

final class FavouriteFoodUseCaseTests: XCTestCase {
    // MARK: - Properties
    private var sut: FavouriteFoodUseCase!
    private var services: MyFavouriteServiceHandlerMock!

    // MARK: - Life Cycle
    override func setUpWithError() throws {
        services = MyFavouriteServiceHandlerMock()
        sut = FavouriteFoodUseCase(repository: services)
    }

    override func tearDownWithError() throws {
        sut = nil
        services = nil
    }
    
    // MARK: - Tests
    func test_favouriteFood_successResponse() throws {
        // Given
        let model = FavouriteFoodStub.getFavouriteFoodModel
        services.favouriteFoodResponse = .success(model)
        // When
        let publisher = sut.getFavouriteFood()
        let result = try awaitPublisher(publisher)
        // Then
        let expectedResult = FavouriteFoodUseCase.State.getFavouriteFoodDidSucceed(response: model)
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_favouriteFood_failureResponse_showError() throws {
        // Given
        let error = "Server error"
        services.favouriteFoodResponse = .failure(.badURL(error))
        // When
        let publisher = sut.getFavouriteFood()
        let result = try awaitPublisher(publisher)
        // Then
        let expectedResult = FavouriteFoodUseCase.State.getFavouriteFoodDidFail(message: error)
        XCTAssertEqual(result, expectedResult, "Expected to show error message but is not happened")
    }
}
