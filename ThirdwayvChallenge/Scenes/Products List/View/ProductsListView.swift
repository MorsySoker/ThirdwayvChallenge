//
//  ProductsListView.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 07/06/2022.
//

import UIKit

final class ProductsListView: UIViewController {
    
    // MARK: - OutLets
    
    @IBOutlet private weak var productsListCollection: UICollectionView!
    @IBOutlet private weak var noInternetConnectionImage: UIImageView!
    
    //MARK: - Properties
    
    private var presenter: ProductsListPresenter?
    
    // MARK: - init
    
    init(presenter: ProductsListPresenter) {
        
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let reachability = try! Reachability()

        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        guard let presenter = presenter else {
            return
        }
        presenter.delegate = self
        presenter.getProducts()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Products List"
        
        setReachabilityObserver()
        setupProductsListCollection()
    }
    
    private func setReachabilityObserver() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: nil)
        updateUserInterface()
    }
    
    private func updateUserInterface() {
        if Network.reachability.isReachable {
            view.backgroundColor = .red
        } else {
            view.backgroundColor = .blue
        }
        switch Network.reachability.status {
        case .unreachable:
            if let presenter = presenter {
                presenter.getCachedProducts()
            }
        case .wwan:
            if let presenter = presenter {
                presenter.getProducts()
            }
        case .wifi:
            if let presenter = presenter {
                presenter.getProducts()
            }
        }
        print("Reachability Summary")
        print("Status:", Network.reachability.status)
        print("HostName:", Network.reachability.hostname ?? "nil")
        print("Reachable:", Network.reachability.isReachable)
        print("Wifi:", Network.reachability.isReachableViaWiFi)
    }
    
    @objc private func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    // MARK: - Methods
    
    private func setupProductsListCollection() {
        
        productsListCollection.collectionViewLayout = setcustomFlowLayout()
        productsListCollection.contentInsetAdjustmentBehavior = .always
        productsListCollection.dataSource = self
        productsListCollection.delegate = self
        productsListCollection.register(cellType: ProductCell.self)
        
        reloadProductsListCollection()
    }
    
    private func setcustomFlowLayout() -> CustomFlowLayout {
        
        let customFlowLayout = CustomFlowLayout()
        customFlowLayout.sectionInsetReference = .fromContentInset
        customFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        customFlowLayout.minimumInteritemSpacing = 0
        customFlowLayout.minimumLineSpacing = 0
        customFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return customFlowLayout
    }
}

// MARK: - Presenter Delegate

extension ProductsListView: ProductsListPresenterViewDelegate {
    
    func reloadProductsListCollection() {
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                self.productsListCollection.reloadData()
            }
        }
    }
    
    func showError(msg: String) {
        print(msg)
    }
}

// MARK: - Collection Delegate

extension ProductsListView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let productDetailsVC = ProductDetailsView()
        
        guard let presenter = presenter,
              let product = presenter.getProductAtIndexPath(indexPath: indexPath.row) else {
            return
        }
        productDetailsVC.configureView(with: product)
        
        pushVC(viewController: productDetailsVC)
    }
}

// MARK: - Collection DataSource

extension ProductsListView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let presenter = presenter else {
            return 0
        }
        return presenter.getProductsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let productCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCell.identifier,
            for: indexPath) as? ProductCell else {
            fatalError("xib doesn't exist")
        }
        
        guard let presenter = presenter,
              let product = presenter.getProductAtIndexPath(indexPath: indexPath.row) else {
            return productCell
        }
        productCell.configureView(with: product)
        
        return productCell
    }
}

// MARK: - ScrollView Delegate

extension ProductsListView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position =  scrollView.contentOffset.y
        
        if position > (productsListCollection.contentSize.height - 20 - scrollView.frame.size.height) {
            guard let presetner = presenter else { return }
            presetner.getMoreProducts()
        }
    }
}
