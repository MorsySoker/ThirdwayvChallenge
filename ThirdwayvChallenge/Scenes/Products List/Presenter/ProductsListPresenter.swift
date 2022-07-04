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
    
    func reloadProductsListCollection()
    func showError(msg: String)
}

final class ProductsListPresenter {
    
    // MARK: - Properties
    
    private var productsList: [ProductsListModel]?
    private let productRepository = ProductsRepository()
    private var serviceManager: ProductsListServiceProtocol?
    private var isFetching: Bool = false
    private var firstFetched: Bool = false
    weak var delegate: ProductsListDelegate?
    
    // MARK: - init
    
    init(serviceManager: ProductsListServiceProtocol) {
        self.serviceManager = serviceManager
    }
    
    //MARK: - Methods
    
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

    func getProducts() {
        
        getCachedProducts()
        
        serviceManager?.getProducts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                self.productsList = products
                self.productRepository.save(products: products)
                self.delegate?.reloadProductsListCollection()
                self.firstFetched = true
            case .failure(let error):
                self.delegate?.showError(msg: error.localizedDescription)
                self.firstFetched = true
            }
        }
    }
    
    func getMoreProducts() {
        guard !isFetching, firstFetched else { return }
        isFetching = true
        
        serviceManager?.getProducts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                self.appendProduct(products: products)
                self.delegate?.reloadProductsListCollection()
                self.isFetching = false
            case .failure(let error):
                self.delegate?.showError(msg: error.localizedDescription)
                self.isFetching = false
            }
        }
    }
    
    func getCachedProducts() {
        
        if let products = productRepository.getProducts() {
            self.productsList = products
        }
    }
    
    private func appendProduct(products: [ProductsListModel]) {
        
        products.forEach { productsList?.append($0) }
    }
}
