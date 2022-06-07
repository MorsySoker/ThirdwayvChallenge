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

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Products List"
        
        setupProductsListCollection()
    }
    
    // MARK: - Private Methods
    
    private func setupProductsListCollection() {
        
        productsListCollection.dataSource = self
        productsListCollection.delegate = self
        
        reloadProductsListCollection()
    }
    
    private func reloadProductsListCollection() {
        
        productsListCollection.reloadData()
    }

}
// MARK: - Collection Delegate

extension ProductsListView: UICollectionViewDelegate {
    
}

// MARK: - Collection DataSource

extension ProductsListView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}
