//
//  ProductsListService.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 09/06/2022.
//

import Foundation

public protocol ProductsListServiceProtocol {
    func getProducts(completion: @escaping (Result<[ProductsListModel], NetworkError>) -> Void)
}

class ProductsListService: ProductsListServiceProtocol {
    
    // MARK: - Properties
    
    private var networkServices: NetworkServiceProtocol
    
    // MARK: - init
    
    init(networkServices: NetworkServiceProtocol = NetworkService()) {
        self.networkServices = networkServices
    }
    
    func getProducts(completion: @escaping (Result<[ProductsListModel], NetworkError>) -> Void){
        let endPoint = ProductsListEndPoint.getProducts
        let request = endPoint.createRequest()
        networkServices.request(request, completion: completion)
    }
}
