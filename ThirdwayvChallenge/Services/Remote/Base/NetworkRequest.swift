//
//  NetworkRequest.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 08/06/2022.
//

import Foundation

protocol EndPoint {
    
    var url: String { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var requestTimeOut: Float? { get }
    var httpMethod: HTTPMethod { get }
}

public struct NetworkRequest: EndPoint {
    let url: String
    let headers: [String: String]?
    let body: Data?
    let requestTimeOut: Float?
    let httpMethod: HTTPMethod

    public init(
        url: String,
        headers: [String: String]? = nil,
        requestBody: Encodable? = nil,
        requestTimeout: Float? = nil,
        httpMethod: HTTPMethod
    ) {
        self.url = url
        self.headers = headers
        self.body = requestBody?.encode()
        self.requestTimeOut = requestTimeout
        self.httpMethod = httpMethod
    }

    public init(
        url: String,
        headers: [String: String]? = nil,
        requestBody: Data? = nil,
        requestTimeout: Float? = nil,
        httpMethod: HTTPMethod
    ) {
        self.url = url
        self.headers = headers
        self.body = requestBody
        self.requestTimeOut = requestTimeout
        self.httpMethod = httpMethod
    }

    func buildURLRequest(with url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers ?? [:]
        urlRequest.httpBody = body
        return urlRequest
    }
}
