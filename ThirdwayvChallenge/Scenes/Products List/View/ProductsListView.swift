//
//  ProductsListView.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 07/06/2022.
//

import UIKit

class ProductsListView: UIViewController {
    
    // MARK: - OutLets
    
    @IBOutlet private weak var productsListCollection: UICollectionView!
    
    //MARK: Properties
    
    private var presenter: ProductsListPresenter?
    
    private var products: [ProductsListModel]?
    
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
        presenter.fetchProducts()
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
        productsListCollection.register(cellType: ProductCell.self)
        
        productsListCollection.dataSource = self
        productsListCollection.delegate = self
        
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
    
    func showProducts(products: [ProductsListModel]) {
        
        self.products = products
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
        guard let products = products else {
            print("Product Not Found")
            return
        }
        
        let product = products[indexPath.row]
        productDetailsVC.configureView(with: product.toProductCellViewModel()!)
        
        pushVC(viewController: productDetailsVC)
    }
}

// MARK: - Collection DataSource

extension ProductsListView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let productCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCell.identifier,
            for: indexPath) as? ProductCell else {
            fatalError("xib doesn't exist")
        }
        
        guard let products = products else {
            print("Products Not Found")
            return productCell
        }
        
        let product = products[indexPath.row]
        
        if let productViewModel = product.toProductCellViewModel() {
            
            productCell.configureView(with: productViewModel)
        }
        
        return productCell
    }
}

// MARK: - ScrollView Delegate

extension ProductsListView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position =  scrollView.contentOffset.y
        
        if position > (productsListCollection.contentSize.height - 100 - scrollView.frame.size.height) {
            
        }
    }
}
