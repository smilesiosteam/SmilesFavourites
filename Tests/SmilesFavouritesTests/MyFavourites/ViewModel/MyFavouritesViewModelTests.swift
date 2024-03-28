//
//  File.swift
//  
//
//  Created by Hafiz Muhammad Junaid on 28/03/2024.
//

import XCTest
import SmilesTests
import Combine
@testable import SmilesFavourites

final class MyFavouritesViewModelTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: MyFavouritesViewModel!
    private var stackListUseCase: StackListUseCaseMock!
    private var wishListUseCase: WishListUseCase!
    private var favouriteVoucherUseCase: FavouriteVoucherUseCaseMock!
    private var favouriteFoodUseCase: FavouriteFoodUseCaseMock!
    
    // MARK: - Life Cycle
    override func setUpWithError() throws {
        stackListUseCase = StackListUseCaseMock()
        wishListUseCase = WishListUseCase()
        favouriteVoucherUseCase = FavouriteVoucherUseCaseMock()
        favouriteFoodUseCase = FavouriteFoodUseCaseMock()
        
        sut = MyFavouritesViewModel(useCase: stackListUseCase, wishListUseCase: wishListUseCase, favouritesVoucherUseCase: favouriteVoucherUseCase, favouriteFoodUseCase: favouriteFoodUseCase)
    }
    
    override func tearDownWithError() throws {
        stackListUseCase = nil
        wishListUseCase = nil
        favouriteVoucherUseCase = nil
        favouriteFoodUseCase = nil
        sut = nil
    }
    
    // MARK: - Tests
    func test_stackList_voucher_success() {
        // Given
        let type = StackListType.voucher
        let model = StackListStub.getFavouriteStackListModel(type: type)
        let result = PublisherSpy(sut.statusPublisher)
        stackListUseCase.stackListUseCaseResponse = .success(.getStackListDidSucceed(response: model))
        // When
        sut.getStackList(with: type)
        // Then
        XCTAssertEqual(type, StackListType.voucher)
        if case let MyFavouritesViewModel.State.stackList(response) = result.value! {
            XCTAssertTrue(response == model)
        } else {
            XCTFail("Expected .stackList, but got \(result.value!)")
        }
    }
    
    func test_stackList_food_success() {
        // Given
        let type = StackListType.food
        let model = StackListStub.getFavouriteStackListModel(type: type)
        let result = PublisherSpy(sut.statusPublisher)
        stackListUseCase.stackListUseCaseResponse = .success(.getStackListDidSucceed(response: model))
        // When
        sut.getStackList(with: type)
        // Then
        XCTAssertEqual(type, StackListType.food)
        if case let MyFavouritesViewModel.State.stackList(response) = result.value! {
            XCTAssertTrue(response == model)
        } else {
            XCTFail("Expected .stackList, but got \(result.value!)")
        }
    }
    
    func test_stackList_voucher_showError() {
        // Given
        let errorMessage = Constants.errorMessage.rawValue
        let result = PublisherSpy(sut.statusPublisher)
        stackListUseCase.stackListUseCaseResponse = .success(.getStackListDidFail(message: errorMessage))
        // When
        let type = StackListType.voucher
        sut.getStackList(with: type)
        // Then
        XCTAssertEqual(type, StackListType.voucher)
        if case let MyFavouritesViewModel.State.showError(message) = result.value! {
            XCTAssertTrue(message == errorMessage)
        } else {
            XCTFail("Expected .showError, but got \(result.value!)")
        }
    }
    
    func test_stackList_food_showError() {
        // Given
        let errorMessage = Constants.errorMessage.rawValue
        let result = PublisherSpy(sut.statusPublisher)
        stackListUseCase.stackListUseCaseResponse = .success(.getStackListDidFail(message: errorMessage))
        // When
        let type = StackListType.food
        sut.getStackList(with: type)
        // Then
        XCTAssertEqual(type, StackListType.food)
        if case let MyFavouritesViewModel.State.showError(message) = result.value! {
            XCTAssertTrue(message == errorMessage)
        } else {
            XCTFail("Expected .showError, but got \(result.value!)")
        }
    }
    
    func test_favouriteFood_success() {
        // Given
        let model = FavouriteFoodStub.getFavouriteFoodModel
        let result = PublisherSpy(sut.statusPublisher)
        favouriteFoodUseCase.favouriteFoodUseCaseResponse = .success(.getFavouriteFoodDidSucceed(response: model))
        // When
        sut.getFavouriteFood()
        // Then
        if case let MyFavouritesViewModel.State.favouriteFood(response) = result.value! {
            XCTAssertTrue(response == model)
        } else {
            XCTFail("Expected .favouriteFood, but got \(result.value!)")
        }
    }
    
    func test_favouriteFood_showError() {
        // Given
        let errorMessage = Constants.errorMessage.rawValue
        let result = PublisherSpy(sut.statusPublisher)
        favouriteFoodUseCase.favouriteFoodUseCaseResponse = .success(.getFavouriteFoodDidFail(message: errorMessage))
        // When
        sut.getFavouriteFood()
        // Then
        if case let MyFavouritesViewModel.State.showError(message) = result.value! {
            XCTAssertTrue(message == errorMessage)
        } else {
            XCTFail("Expected .showError, but got \(result.value!)")
        }
    }
}
