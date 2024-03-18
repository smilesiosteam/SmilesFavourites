//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 07/03/2024.
//

import Foundation
import NetworkingLayer

public enum MyFavouritesConfigurator {
    public static func getMyFavouritesView(showBackButton: Bool = false, delegate: MyFavouritesViewControllerDelegate?) -> MyFavouritesViewController {
        let stackListUseCase = StackListUseCase(repository: repository)
        let wishListUseCase = WishListUseCase()
        let favouriteVoucherUseCase = FavouriteVoucherUseCase(repository: repository)
        let favouriteFoodUseCase = FavouriteFoodUseCase(repository: repository)
        let viewModel = MyFavouritesViewModel(useCase: stackListUseCase, wishListUseCase: wishListUseCase, favouritesVoucherUseCase: favouriteVoucherUseCase, favouriteFoodUseCase: favouriteFoodUseCase)
        let viewController = MyFavouritesViewController.create()
        viewController.delegate = delegate
        viewController.viewModel = viewModel
        viewController.showBackButton = showBackButton
        viewController.segmentCollectionViewDataSource = SegmentsCollectionViewDataSource(arraySegments: viewModel.arraySegments)
        viewController.tableViewDelegate = MyFavouritesTableViewDelegate()
        
        return viewController
    }
    
    static var network: Requestable {
        NetworkingLayerRequestable(requestTimeOut: 60)
    }
    
    static var repository: MyFavouritesServiceable {
        MyFavouritesRepository(networkRequest: network)
    }
}
