//
//  ProductsListPresenter.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 09/06/2022.
//

import Foundation
import UIKit

// MARK: - Preseter Delegate

typealias ProductsListDelegate = ProductsListPresenterViewDelegate & UIViewController

protocol ProductsListPresenterViewDelegate: AnyObject {
    
    func showProducts()
    func showError(msg: String)
}

final class ProductsListPresenter {
    
    // MARK: - Properties
    
    private var productsList: [ProductsListModel]?
    private let cache = Cache<String, [ProductsListModel]>()
    private var serviceManager: ProductsListServiceProtocol?
    private weak var delegate: ProductsListDelegate?
    private var isPaginating: Bool = false
    
    // MARK: - init
    
    init(serviceManager: ProductsListServiceProtocol) {
        self.serviceManager = serviceManager
    }
    
    //MARK: - Methods
    
    //Set View Delegate
    func setViewDelegate(delegate: ProductsListDelegate) {
        self.delegate = delegate
    }
    
    func getProductsCount() -> Int {
        guard let productsList = productsList else {
            return 0
        }
        return productsList.count
    }
    
    func getProductAtIndexPath(indexPath: Int) -> ProductCellViewModel? {
        guard let productsList = productsList else {
            return nil
        }
        return productsList[indexPath].toProductCellViewModel()
    }
    
    func getIsPaginating() -> Bool {
        
        isPaginating
    }

    private func appendProduct(products: [ProductsListModel]) {
        
        products.forEach { productsList?.append($0) }
    }
    // MARK: - Methods
    
    func fetchProducts(paginating: Bool) {
        
        if let products = cache.value(forKey: "products"),
           !paginating {
            print("hey it's cached")
            self.productsList = products
        }
        if paginating {
            isPaginating = true
        }
        serviceManager?.getProducts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                if paginating {
                    self.appendProduct(products: products)
                    self.isPaginating = false
                } else {
                    self.productsList = products
                    self.cache.insert(products, forKey: "products")
                        print("cached")
                }
                self.delegate?.showProducts()
            case .failure(let error):
                self.delegate?.showError(msg: error.localizedDescription)
                if paginating {
                    self.isPaginating = false
                }
            }
        }
        
    }
}
