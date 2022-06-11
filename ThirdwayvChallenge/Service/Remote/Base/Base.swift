//
//  Base.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 08/06/2022.
//

import Foundation

typealias Headers = [String: String]

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

public enum NetworkError: Error, Equatable {
    case badURL(_ error: String)
    case apiError(code: Int, error: String)
    case invalidJSON(_ error: String)
    case unauthorized(code: Int, error: String)
    case badRequest(code: Int, error: String)
    case serverError(code: Int, error: String)
    case noResponse(_ error: String)
    case unableToParseData(_ error: String)
    case unknown(code: Int, error: String)
}

extension Encodable {
    func encode() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            return nil
        }
    }
}
