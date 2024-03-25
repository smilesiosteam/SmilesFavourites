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
    private var snackbar: SnackbarView?
    private var stackCards: [StackCard]?
    
    // MARK: - Life Cycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTableViewDataSource()
        configureSections()
        setUpNavigationBar()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.removeSnackbar()
        self.viewModel?.removeFromFavourites()
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
                
            case .updateWishList(let response, let operation):
                print(response)
                self.configureUpdateWishList(operation: operation)
                
            case .favouriteVoucher(let response):
                if viewModel?.stackListType == .voucher {
                    self.configureFavoriteVoucher(with: response)
                }
                
            case .favouriteFood(let response):
                if viewModel?.stackListType == .food {
                    self.configureFavouriteFood(with: response)
                }
            }
        }.store(in: &cancellables)
    }
    
    private func bindSegmentsDataSource() {
        segmentCollectionViewDataSource?.statusPublisher.sink { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .didSelectItem(let index):
                self.removeSnackbar()
                self.viewModel?.removeFromFavourites()
                
                self.segmentsCollectionView.reloadData()
                if let stackListType = StackListType(rawValue: index) {
                    self.viewModel?.stackListType = stackListType
                    
                    self.resetTableViewDataSource()
                    self.configureSections()
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
        viewModel?.badgeCount = 0
        viewModel?.swipeCount = 0
        viewModel?.hasStackList = false
        viewModel?.hasFavourites = false
        viewModel?.didUpdateSwipeMessage = false
        dataSource?.dataSources?.removeAll()
    }
    
    private func configureSections() {
        dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: viewModel?.sections.count ?? 0))
        configureDataSource()
        sections.removeAll()
        
        for (index, element) in (viewModel?.sections ?? []).enumerated() {
            let section = element.identifier
            sections.append(TableSectionData(index: index, identifier: section))
            
            switch section {
            case .swipeMessage:
                if let viewModel = SwipeMessageViewModel.fromModuleFile() {
                    self.dataSource?.dataSources?[index] = TableViewDataSource.make(forSwipeMessage: viewModel, data: "#FFFFFF", isDummy: true)
                }
            case .stackList:
                if let response = FavouriteStackListResponse.fromModuleFile() {
                    let viewModel = FavouritesStackListTableViewCell.ViewModel(swipeCards: response.stackList, stackListType: viewModel?.stackListType ?? .voucher, delegate: self)
                    self.dataSource?.dataSources?[index] = TableViewDataSource.make(forStackList: response, viewModel: viewModel, data: "#FFFFFF", isDummy: true)
                }
                
                viewModel?.getStackList(with: viewModel?.stackListType ?? .voucher)
            case .favouritesList:
                if viewModel?.stackListType == .voucher {
                    if let offersCategory = OffersCategoryResponseModel.fromFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forFavouriteVoucher: offersCategory.offers ?? [], data: "#FFFFFF", isDummy: true, completion: nil)
                    }
                } else {
                    if let response = [Restaurant].fromFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forFavouriteFood: response, data:"#FFFFFF", isDummy: true, completion: nil)
                    }
                }
                
                viewModel?.getFavourites()
            }
        }
        
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Private TableView Configure Methods
    private func configureSwipeMessage(with viewModel: SwipeMessageViewModel) {
        if let index = getSectionIndex(for: .swipeMessage) {
            self.dataSource?.dataSources?[index] = TableViewDataSource.make(forSwipeMessage: viewModel, data: "#FFFFFF")
            
            tableView.dataSource = dataSource
            tableView.reloadSections([index], with: .automatic)
        }
    }
    
    private func configureSwipeMessageState() {
        if (viewModel?.hasStackList ?? false) && !(viewModel?.hasFavourites ?? false) {
            let swipeMessageState = SwipeMessageState.favouritesListEmpty.state
            let viewModel = SwipeMessageViewModel(iconImage: swipeMessageState.icon, title: swipeMessageState.title, message: swipeMessageState.message, badgeCount: 0)
            configureSwipeMessage(with: viewModel)
        } else if (viewModel?.hasStackList ?? false) && (viewModel?.hasFavourites ?? false) {
            let swipeMessageState = SwipeMessageState.swipeToAddToFavouritesWithoutSwipe.state
            let viewModel = SwipeMessageViewModel(iconImage: swipeMessageState.icon, title: swipeMessageState.title, message: swipeMessageState.message, badgeCount: 0)
            configureSwipeMessage(with: viewModel)
        }
    }
    
    private func updateSwipeMessage(with viewModel: SwipeMessageViewModel) {
        if let index = getSectionIndex(for: .swipeMessage) {
            dataSource?.dataSources?[index] = TableViewDataSource.make(forSwipeMessage: viewModel, data: "#FFFFFF")
            tableView.dataSource = dataSource
            tableView.reloadSections([index], with: .automatic)
        }
    }
    
    private func configureStackList(with response: FavouriteStackListResponse) {
        if let stackList = response.stackList, !stackList.isEmpty {
            stackCards = stackList
            viewModel?.hasStackList = true
            
            if let index = getSectionIndex(for: .stackList) {
                let favouritesStackListViewModel = FavouritesStackListTableViewCell.ViewModel(swipeCards: stackList, stackListType: viewModel?.stackListType ?? .voucher, delegate: self)
                self.dataSource?.dataSources?[index] = TableViewDataSource.make(forStackList: response, viewModel: favouritesStackListViewModel, data: "#FFFFFF")
            }
            
            configureDataSource()
        } else {
            viewModel?.hasStackList = false
            configureHideSection(for: .swipeMessage, dataSource: SwipeMessageViewModel.self)
            configureHideSection(for: .stackList, dataSource: FavouriteStackListResponse.self)
        }
    }
    
    private func configureFavoriteVoucher(with response: FavouriteVoucherResponse) {
        if let voucherList = response.offers, !voucherList.isEmpty {
            viewModel?.hasFavourites = true
            if !(viewModel?.didUpdateSwipeMessage ?? false) {
                configureSwipeMessageState()
            }
            
            if let index = getSectionIndex(for: .favouritesList) {
                self.dataSource?.dataSources?[index] = TableViewDataSource.make(forFavouriteVoucher: voucherList, data: "#FFFFFF", completion: { [weak self] isFavorite, offerId, indexPath in
                    
                    if let indexPath {
                        if let vouchers = self?.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<OfferDO>? {
                            self?.viewModel?.removeFromFavourites()
                            self?.showSnackbar()
                            self?.viewModel?.removeFavouriteData = vouchers?.models?[indexPath.row]
                            self?.viewModel?.removeIndexPath = indexPath
                            (self?.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<OfferDO>)?.models?.remove(at: indexPath.row)
                            self?.tableView.reloadSections([index], with: .automatic)
                        }
                    }
                })
                
                tableView.dataSource = dataSource
                tableView.reloadSections([index], with: .automatic)
            }
        } else {
            viewModel?.hasFavourites = false
            configureSwipeMessageState()
            configureHideSection(for: .favouritesList, dataSource: OfferDO.self)
        }
    }
    
    private func configureFavouriteFood(with response: FavouriteFoodResponse) {
        if let foodList = response.restaurants, !foodList.isEmpty {
            viewModel?.hasFavourites = true
            if !(viewModel?.didUpdateSwipeMessage ?? false) {
                configureSwipeMessageState()
            }
            
            if let index = getSectionIndex(for: .favouritesList) {
                self.dataSource?.dataSources?[index] = TableViewDataSource.make(forFavouriteFood: foodList, data: "#FFFFFF", completion: { [weak self] isFavorite, restaurantId, indexPath in
                    
                    if let indexPath = indexPath {
                        if let foods = self?.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<Restaurant>? {
                            self?.viewModel?.removeFromFavourites()
                            self?.showSnackbar()
                            self?.viewModel?.removeFavouriteData = foods?.models?[indexPath.row]
                            self?.viewModel?.removeIndexPath = indexPath
                            (self?.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<Restaurant>)?.models?.remove(at: indexPath.row)
                            self?.tableView.reloadSections([index], with: .automatic)
                        }
                    }
                })
                
                tableView.dataSource = dataSource
                tableView.reloadSections([index], with: .automatic)
            }
        } else {
            viewModel?.hasFavourites = false
            configureSwipeMessageState()
            configureHideSection(for: .favouritesList, dataSource: Restaurant.self)
        }
    }
    
    private func configureUpdateWishList(operation: Int) {
        if stackCards?.count == self.viewModel?.swipeCount {
            let swipeMessageState = SwipeMessageState.greatJob.state
            let viewModel = SwipeMessageViewModel(iconImage: swipeMessageState.icon, title: swipeMessageState.title, message: swipeMessageState.message, badgeCount: 0)
            updateSwipeMessage(with: viewModel)
            configureHideSection(for: .stackList, dataSource: FavouriteStackListResponse.self)
            
            self.viewModel?.didUpdateSwipeMessage = true
            self.viewModel?.getFavourites()
        } else {
            if operation == 1 {
                let swipeMessageState = SwipeMessageState.swipeToAddToFavouritesWithSwipe.state
                let viewModel = SwipeMessageViewModel(iconImage: swipeMessageState.icon, title: swipeMessageState.title, message: swipeMessageState.message, badgeCount: viewModel?.badgeCount)
                updateSwipeMessage(with: viewModel)
                
                self.viewModel?.didUpdateSwipeMessage = true
                self.viewModel?.getFavourites()
            }
        }

        self.viewModel?.resetRemoveFavourites()
    }
    
    private func showSnackbar() {
        removeSnackbar()
        snackbar = SnackbarView(message: SmilesFavouritesLocalization.removedFromFavouritesTitle.text, actionTitle: SmilesFavouritesLocalization.undoTitle.text)
        snackbar?.show(in: self.view)
        snackbar?.actionHandler = { [weak self] in
            self?.snackbar = nil
            if self?.viewModel?.stackListType == .voucher {
                if let offerData = self?.viewModel?.removeFavouriteData as? OfferDO,
                   let indexPath = self?.viewModel?.removeIndexPath {
                    (self?.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<OfferDO>)?.models?.insert(offerData, at: indexPath.row)
                    self?.viewModel?.undoFavourites()
                    self?.tableView.reloadData()
                }
            }
            else if self?.viewModel?.stackListType == .food {
                if let foodData = self?.viewModel?.removeFavouriteData as? Restaurant,
                   let indexPath = self?.viewModel?.removeIndexPath {
                    (self?.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<Restaurant>)?.models?.insert(foodData, at: indexPath.row)
                    self?.viewModel?.undoFavourites()
                    self?.tableView.reloadData()
                }
            }
        }
        snackbar?.completion = { [weak self] in
            self?.viewModel?.removeFromFavourites()
            self?.snackbar = nil
        }
    }
    
    func removeSnackbar() {
        snackbar?.removeFromSuperview()
        snackbar?.completion = nil
        snackbar = nil
    }
    
    private func getSectionIndex(for identifier: SmilesFavouritesSectionIdentifier) -> Int? {
        return sections.first(where: { obj in
            return obj.identifier == identifier
        })?.index
    }
    
    private func configureHideSection<T>(for section: SmilesFavouritesSectionIdentifier, dataSource: T.Type) {
        if let index = getSectionIndex(for: section) {
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.models = []
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.isDummy = false
            
            self.configureDataSource()
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
            viewModel?.updateWishList(id: card.stackId ?? "", operation: direction.operation, didSwipe: true)
        }
    }
}
