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
import SmilesOffers

public protocol MyFavouritesViewControllerDelegate: AnyObject {
    func didSelectVoucher(voucherData: OfferDO)
    func didSelectFood(foodData: Restaurant)
}

public class MyFavouritesViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var segmentsCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomBorder: UIView!
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: SectionedTableViewDataSource?
    private var sections = [TableSectionData<SmilesFavouritesSectionIdentifier>]() {
        didSet {
            tableViewDelegate?.sections = sections
        }
    }
    
    var segmentCollectionViewDataSource: SegmentsCollectionViewDataSource?
    var tableViewDelegate: MyFavouritesTableViewDelegate?
    var viewModel: MyFavouritesViewModel?
    var showBackButton: Bool = false
    public weak var delegate: MyFavouritesViewControllerDelegate? = nil
    
    // MARK: - Life Cycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTableViewDataSource()
        viewModel?.getStackList(with: viewModel?.stackListType ?? .voucher)
        viewModel?.getFavourites()
        
        setUpNavigationBar()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindSegmentsDataSource()
        setupUI()
        setupCollectionView()
        bindTableViewDelegate()
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
        tableView.allowsSelection = true
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 1
        tableView.delegate = tableViewDelegate
        
        let customizable: CellRegisterable? = SmilesFavouritesCellRegistration()
        customizable?.register(for: self.tableView)
        self.tableView.backgroundColor = .white
        
        dataSource = SectionedTableViewDataSource(dataSources: [])
    }
    
    private func setUpNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        
        let locationNavBarTitle = UILabel()
        locationNavBarTitle.text = SmilesFavouritesLocalization.favourites.text
        locationNavBarTitle.textColor = .black
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        let hStack = UIStackView(arrangedSubviews: [locationNavBarTitle])
        hStack.spacing = 4
        hStack.alignment = .center
        self.navigationItem.titleView = hStack
        
        if showBackButton {
            let btnBack: UIButton = UIButton(type: .custom)
            btnBack.backgroundColor = .white
            btnBack.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "BackArrow_black_Ar" : "BackArrow_black", in: .module, with: nil), for: .normal)
            btnBack.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            btnBack.layer.cornerRadius = btnBack.frame.height / 2
            btnBack.clipsToBounds = true
            btnBack.tintColor = .black
            let barButton = UIBarButtonItem(customView: btnBack)
            self.navigationItem.leftBarButtonItem = barButton
        }
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
                
            case .updateWishList(let response):
                print(response)
                self.resetTableViewDataSource()
                self.viewModel?.getFavourites()
            case .favouriteVoucher(let response):
                self.configureFavoriteVoucher(with: response)
                
            case .favouriteFood(let response):
                self.configureFavouriteFood(with: response)
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
                    
                    self.resetTableViewDataSource()
                    self.viewModel?.getStackList(with: stackListType)
                    self.viewModel?.getFavourites()
                }
            }
        }.store(in: &cancellables)
    }
    
    private func bindTableViewDelegate() {
        tableViewDelegate?.statusPublisher.sink { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .didSelectRow(let indexPath):
                if viewModel?.stackListType == .voucher {
                    if let voucherItem = (self.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<OfferDO>)?.models?[safe: indexPath.row] as? OfferDO {
                        self.delegate?.didSelectVoucher(voucherData: voucherItem)
                    }
                }
                else {
                    if let foodItem = (self.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<Restaurant>)?.models?[safe: indexPath.row] as? Restaurant {
                        self.delegate?.didSelectFood(foodData: foodItem)
                    }
                }
            }
            
        }.store(in: &cancellables)
    }
    
    private func resetTableViewDataSource() {
        sections.removeAll()
        dataSource?.dataSources?.removeAll()
        tableView.reloadData()
    }
    
    // MARK: - Private TableView Configure Methods
    private func configureStackList(with response: FavouriteStackListResponse) {
        if let stackList = response.stackList, !stackList.isEmpty {
            let viewModel = FavouritesStackListTableViewCell.ViewModel(iconImage: .favouritesEmptyIcon, title: SmilesFavouritesLocalization.favouriteListEmptyMessage.text, message: SmilesFavouritesLocalization.swipeStackListMessage.text, badgeCount: 0, swipeCards: stackList, stackListType: viewModel?.stackListType ?? .voucher, delegate: self)
            let dataSource = TableViewDataSource.make(forStackList: response, viewModel: viewModel, data: "#FFFFFF")
            self.dataSource?.dataSources?.append(dataSource)
            sections.append(TableSectionData(index: 0, identifier: .stackList))
            
            configureDataSource()
        }
    }
    
    private func configureFavoriteVoucher(with response: FavouriteVoucherResponse) {
        if let voucherList = response.offers, !voucherList.isEmpty {
            let dataSource = TableViewDataSource.make(forFavouriteVoucher: voucherList, data: "#FFFFFF", completion: { [weak self] isFavorite, offerId, indexPath in
                self?.viewModel?.updateWishList(id: offerId, operation: 2)
            })
            self.dataSource?.dataSources?.append(dataSource)
            sections.append(TableSectionData(index: sections.count, identifier: .favouritesList))
            
            configureDataSource()
        }
    }
    
    private func configureFavouriteFood(with response: FavouriteFoodResponse) {
        if let foodList = response.restaurants, !foodList.isEmpty {
            let dataSource = TableViewDataSource.make(forFavouriteFood: foodList, data: "#FFFFFF", completion: { [weak self] isFavorite, restaurantId, indexPath in
                self?.viewModel?.updateWishList(id: restaurantId, operation: 2)
            })
            self.dataSource?.dataSources?.append(dataSource)
            sections.append(TableSectionData(index: sections.count, identifier: .favouritesList))
            
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

// MARK: - FavouritesStackListTableViewCellDelegate
extension MyFavouritesViewController: FavouritesStackListTableViewCellDelegate {
    func didSwipeCard(with card: StackCard?, direction: CardSwipeDirection) {
        if let card {
            viewModel?.updateWishList(id: card.stackId ?? "", operation: direction.operation)
        }
    }
}
