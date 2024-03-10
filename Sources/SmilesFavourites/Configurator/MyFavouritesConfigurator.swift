//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 07/03/2024.
//

import Foundation
import NetworkingLayer

public enum MyFavouritesConfigurator {
    public static func getMyFavouritesView() -> MyFavouritesViewController {
        let stackListUseCase = StackListUseCase(repository: repository)
        let viewModel = MyFavouritesViewModel(useCase: stackListUseCase)
        let viewController = MyFavouritesViewController.create()
        viewController.viewModel = viewModel
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
