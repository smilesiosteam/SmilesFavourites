//
//  MyFavoritesViewController.swift
//  House
//
//  Created by Hafiz Muhammad Junaid on 05/03/2024.
//  Copyright © 2024 Ahmed samir ali. All rights reserved.
//

import UIKit
import Combine
import SmilesUtilities

public class MyFavouritesViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var segmentsCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomBorder: UIView!
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: SectionedTableViewDataSource?
    private var sections = [TableSectionData<SmilesFavouritesSectionIdentifier>]()
    
    var segmentCollectionViewDataSource: SegmentsCollectionViewDataSource?
    var tableViewDelegate: MyFavouritesTableViewDelegate?
    var viewModel: MyFavouritesViewModel?
    
    // MARK: - Life Cycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetDataSource()
        viewModel?.getStackList(with: .voucher)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindSegmentsDataSource()
        setupUI()
        setupCollectionView()
        setupTableView()
    }
    
    // MARK: - Private Helper Methods
    private func setupUI() {
        bottomBorder.backgroundColor = .disabledColor
    }
    
    private func setupCollectionView() {
        segmentsCollectionView.dataSource = segmentCollectionViewDataSource
        segmentsCollectionView.delegate = segmentCollectionViewDataSource
        
        segmentsCollectionView.register(nib: UINib(nibName: String(describing: MyFavoritesSegmentCollectionViewCell.self), bundle: .module), forCellWithClass: MyFavoritesSegmentCollectionViewCell.self)
    }
    
    private func setupTableView() {
        self.tableView.sectionFooterHeight = .leastNormalMagnitude
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = CGFloat(0)
        }
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 1
        tableView.delegate = tableViewDelegate
        
        let customizable: CellRegisterable? = SmilesFavouritesCellRegistration()
        customizable?.register(for: self.tableView)
        self.tableView.backgroundColor = .white
        
        dataSource = SectionedTableViewDataSource(dataSources: [])
    }
    
    private func configureDataSource() {
        tableView.dataSource = dataSource
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func bindViewModel() {
        viewModel?.statusPublisher.sink { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .showError(let error):
                print(error)
                
            case .stackList(let response):
                self.configureStackList(with: response)
            }
        }.store(in: &cancellables)
    }
    
    private func bindSegmentsDataSource() {
        segmentCollectionViewDataSource?.statusPublisher.sink { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .didSelectItem(let index):
                self.segmentsCollectionView.reloadData()
                if let stackListType = StackListType(rawValue: index) {
                    self.viewModel?.stackListType = stackListType
                }
            }
        }.store(in: &cancellables)
    }
    
    private func resetDataSource() {
        sections.removeAll()
        dataSource?.dataSources?.removeAll()
    }
    
    // MARK: - Private TableView Configure Methods
    private func configureStackList(with response: FavouriteStackListResponse) {
        if let stackList = response.stackList, !stackList.isEmpty {
            let viewModel = FavouritesStackListTableViewCell.ViewModel(iconImage: .favouritesEmptyIcon, title: SmilesFavouritesLocalization.favouriteListEmptyMessage.text, message: SmilesFavouritesLocalization.swipeStackListMessage.text, badgeCount: 0, swipeCards: stackList, stackListType: viewModel?.stackListType ?? .voucher)
            let dataSource = TableViewDataSource.make(forStackList: response, viewModel: viewModel, data: "#FFFFFF")
            self.dataSource?.dataSources?.append(dataSource)
            sections.append(TableSectionData(index: 0, identifier: .stackList))
            
            configureDataSource()
        }
    }
}

// MARK: - Create
extension MyFavouritesViewController {
    static public func create() -> MyFavouritesViewController {
        let viewController = MyFavouritesViewController(nibName: String(describing: MyFavouritesViewController.self), bundle: .module)
        return viewController
    }
}
