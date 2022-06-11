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
    
    //MARK: Properties
    
    private var presenter: ProductsListPresenter?
    
    // MARK: - init
    
    init(service: ProductsListServiceProtocol) {
        
        self.presenter = ProductsListPresenter(serviceManager: service)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let presenter = presenter else {
            return
        }
        presenter.setViewDelegate(delegate: self)
        presenter.fetchProducts(paginating: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Products List"
        
        setupProductsListCollection()
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
    
    private func reloadProductsListCollection() {
        DispatchQueue.main.async {
            self.productsListCollection.reloadData()
        }
    }
}

// MARK: - Presenter Delegate

extension ProductsListView: ProductsListPresenterViewDelegate {
    
    func showProducts() {
        
        reloadProductsListCollection()
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
        
        if position > (productsListCollection.contentSize.height - 100 - scrollView.frame.size.height) {
            guard let presetner = presenter,
                  !presetner.getIsPaginating() else { return }
            presetner.fetchProducts(paginating: true)
        }
    }
}
