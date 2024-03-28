//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 28/03/2024.
//

import XCTest
import SmilesTests
@testable import SmilesFavourites

final class StackListUseCaseTests: XCTestCase {
    // MARK: - Properties
    private var sut: StackListUseCase!
    private var services: MyFavouriteServiceHandlerMock!

    // MARK: - Life Cycle
    override func setUpWithError() throws {
        services = MyFavouriteServiceHandlerMock()
        sut = StackListUseCase(repository: services)
    }

    override func tearDownWithError() throws {
        sut = nil
        services = nil
    }
    
    // MARK: - Tests
    func test_stackList_food_successResponse() throws {
        // Given
        let model = StackListStub.getFavouriteStackListFoodModel
        services.favouriteStackListResponse = .success(model)
        let type = StackListType.food
        // When
        let publisher = sut.getStackList(type: type)
        let result = try awaitPublisher(publisher)
        // Then
        let expectedResult = StackListUseCase.State.getStackListDidSucceed(response: model)
        XCTAssertEqual(type, StackListType.food)
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_stackList_voucher_successResponse() throws {
        // Given
        let model = StackListStub.getFavouriteStackListVoucherModel
        services.favouriteStackListResponse = .success(model)
        let type = StackListType.voucher
        // When
        let publisher = sut.getStackList(type: type)
        let result = try awaitPublisher(publisher)
        // Then
        let expectedResult = StackListUseCase.State.getStackListDidSucceed(response: model)
        XCTAssertEqual(type, StackListType.voucher)
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_stackList_failureResponse_showError() throws {
        // Given
        let error = "Server error"
        services.favouriteStackListResponse = .failure(.badURL(error))
        // When
        let publisher = sut.getStackList(type: .food)
        let result = try awaitPublisher(publisher)
        // Then
        let expectedResult = StackListUseCase.State.getStackListDidFail(message: error)
        XCTAssertEqual(result, expectedResult, "Expected to show error message but is not happened")
    }
}
