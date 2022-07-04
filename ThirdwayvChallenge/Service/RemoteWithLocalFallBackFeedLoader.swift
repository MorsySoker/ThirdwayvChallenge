//
//  RemoteWithLocalFallBackFeedLoader.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 04/07/2022.
//

import Foundation

class RemoteWithLocalFallBackFeedLoader: ProductsLoader {

    let remoteLoader: ProductsLoader
    let localLoader: ProductsRepositoryProtocol
    private let reachability = try! Reachability()
    
    init(remoteLoader: ProductsLoader, localLoader: ProductsRepositoryProtocol) {
        self.remoteLoader = remoteLoader
        self.localLoader = localLoader
    }
    
    func getProducts(completion: @escaping (Result<[ProductsListModel], NetworkError>) -> Void) {
        
        reachability.whenReachable = { [weak self] reachability in
            print("Reachable")
            self?.remoteLoader.getProducts { result in
                switch result {
                case .success(let products):
                    completion(.success(products))
                    self?.localLoader.save(products: products)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        reachability.whenUnreachable = { [weak self] _ in
            print("Not reachable")
            self?.localLoader.getProducts(completion: completion)
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
