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
    
    func showProducts(products: [ProductsListModel])
    func showError(msg: String)
}

final class ProductsListPresenter {
    
    // MARK: - Properties
    
    var serviceManager: ProductsListServiceProtocol?
    weak var delegate: ProductsListDelegate?
    
    // MARK: - init
    
    init(serviceManager: ProductsListServiceProtocol) {
        self.serviceManager = serviceManager
    }
    
    //MARK: - Set View Delegate
    
    func setViewDelegate(delegate: ProductsListDelegate) {
        self.delegate = delegate
    }

    // MARK: - Methods
    
    func fetchProducts() {
        
        serviceManager?.getProducts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let products):
                self.delegate?.showProducts(products: products)
            case .failure(let error):
                self.delegate?.showError(msg: error.localizedDescription)
            }
        }
    }
}
