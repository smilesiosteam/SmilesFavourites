//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 22/03/2024.
//

import XCTest
import SmilesTests
@testable import SmilesFavourites

final class FavouriteVoucherUseCaseTests: XCTestCase {
    // MARK: - Properties
    private var sut: FavouriteVoucherUseCase!
    private var services: MyFavouriteServiceHandlerMock!

    // MARK: - Life Cycle
    override func setUpWithError() throws {
        services = MyFavouriteServiceHandlerMock()
        sut = FavouriteVoucherUseCase(repository: services)
    }

    override func tearDownWithError() throws {
        sut = nil
        services = nil
    }
    
    // MARK: - Tests
    func test_favouriteVoucher_successResponse() throws {
        // Given
        let model = FavouriteVoucherStub.getFavouriteVoucherModel
        services.favouriteVoucherResponse = .success(model)
        let pageNumber = 1
        // When
        let publisher = sut.getFavouriteVoucher(withCurrentLocation: nil, pageNumber: pageNumber)
        let result = try awaitPublisher(publisher)
        // Then
        let expectedResult = FavouriteVoucherUseCase.State.getFavouriteVoucherDidSucceed(response: model)
        XCTAssertEqual(result, expectedResult, "teste")
    }
    
    func test_favouriteVoucher_failureResponse_showError() throws {
        // Given
        let error = "Server error"
        services.favouriteVoucherResponse = .failure(.badURL(error))
        let pageNumber = 1
        // When
        let publisher = sut.getFavouriteVoucher(withCurrentLocation: nil, pageNumber: pageNumber)
        let result = try awaitPublisher(publisher)
        // Then
        let expectedResult = FavouriteVoucherUseCase.State.getFavouriteVoucherDidFail(message: error)
        XCTAssertEqual(result, expectedResult, "Expected to show error message but is not happened")
    }
}
