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
    
    private let presenter =  ProductsListPresenter(serviceManager: ProductsListService())
    
    private var products: [ProductsListModel]?

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Products List"
        
        setupProductsListCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.setViewDelegate(delegate: self)
        presenter.fetchProducts()
    }
    
    // MARK: - Methods
    
    private func setupProductsListCollection() {

        productsListCollection.register(cellType: ProductCell.self)
        
        productsListCollection.dataSource = self
        productsListCollection.delegate = self
        
        reloadProductsListCollection()
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
        print("sucsess\(products.count)")
        reloadProductsListCollection()
    }
    
    func showError(msg: String) {
        //
    }
}

// MARK: - Collection Delegate

extension ProductsListView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Hey \(indexPath.row)")
    }
}

// MARK: - Collection DataSource

extension ProductsListView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let productCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCell.identifier,
            for: indexPath) as? ProductCell else { fatalError("xib doesn't exist") }
        
        productCell.configureView(with: 308)
        
        print("cell \(indexPath.row)")
        
        return productCell
    }
}

// MARK: - Collection Delegate FlowLayout

extension ProductsListView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: collectionView.bounds.width / 2,
               height: 500)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
