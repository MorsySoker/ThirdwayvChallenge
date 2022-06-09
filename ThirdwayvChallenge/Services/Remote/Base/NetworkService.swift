//
//  NetworkService.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 08/06/2022.
//

import Foundation

import Combine

public protocol NetworkServiceProtocol {
    
    var requestTimeOut: Float { get }
    func request<T: Codable>(_ request: NetworkRequest,
                    completion: @escaping (Result<T, NetworkError>) -> Void)
}

public class NetworkService: NetworkServiceProtocol {
    
    
    // MARK: - Properties
    
    public var requestTimeOut: Float
    
    // MARK: - Init
    
    public init() {
        requestTimeOut = 30.0
    }
    
    // MARK: - Methods
    
    public func request<T: Codable>(_ request: NetworkRequest,
                           completion: @escaping (Result<T, NetworkError>) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(
            request.requestTimeOut ?? requestTimeOut)
        
        guard let url = URL(string: request.url) else {
            completion(.failure(NetworkError.badURL("Bad URL")))
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request.buildURLRequest(with: url)) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(NetworkError.unknown(code: 0, error: error.localizedDescription)))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self,
                                                      from: data)
                completion(.success(result))
                
            } catch {
                
                completion(.failure(NetworkError.invalidJSON("Could Not Decode Json")))
            }
        }
        
        task.resume()
    }
}
