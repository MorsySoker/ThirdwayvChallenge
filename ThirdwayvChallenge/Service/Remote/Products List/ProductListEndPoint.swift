//
//  ProductListEndPoint.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 09/06/2022.
//

import Foundation

enum ProductsListEndPoint {
    
    case getProducts
    
    var requestTimeOut: Int {
        return 20
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getProducts: return .GET
        }
    }
    
    var requestBody: Encodable? {
        switch self {
        default:
            return nil
        }
    }
    
    func getURL() -> String {
        switch self {
        case .getProducts:
            return Enviroment.baseURL
        }
    }
    
    func createRequest(token: String? = nil) -> NetworkRequest {
        var headers: Headers = [:]
        headers["Content-Type"] = "application/json"
        if let token = token {
            headers["Authorization"] = "Bearer \(token)"
        }
        return NetworkRequest(url: getURL(),
                              headers: headers,
                              requestBody: requestBody,
                              httpMethod: httpMethod)
    }
}
