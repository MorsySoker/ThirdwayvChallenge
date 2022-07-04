//
//  ProductsRepository.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 11/06/2022.
//

import Foundation

protocol ProductsRepositoryProtocol: ProductsLoader {
    
    func save(products: [ProductsListModel])
    func removeProducts()
}

class ProductsRepository: ProductsRepositoryProtocol {
    
    struct ProductsKey {

        static let products = "products"
    }
    
    // MARK: - Properties
    
    private let  cache = Cache<String, [ProductsListModel]>()
    
    // MARK: - Methods

    func save(products: [ProductsListModel]) {
        
        cache.insert(products, forKey: ProductsKey.products)
        do { try cache.saveToDisk(withName: ProductsKey.products) }
        catch { print("FailedTo cache") }
    }
    
    func getProducts(completion: @escaping (Result<[ProductsListModel], NetworkError>) -> Void) {
        guard let products = cache.value(forKey: ProductsKey.products) else {
            return
        }
        completion(.success(products))
    }
    
    func removeProducts() {
        cache.removeValue(forKey: ProductsKey.products)
    }
    
}
