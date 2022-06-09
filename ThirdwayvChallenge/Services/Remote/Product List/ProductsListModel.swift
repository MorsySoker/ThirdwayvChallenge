//
//  ProductsListModel.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 09/06/2022.
//

import Foundation

// MARK: - ProductsListModel
public struct ProductsListModel: Codable {
    let id: Int
    let productDescription: String
    let image: ProductImage
    let price: Int
}

// MARK: - ProductImage
public struct ProductImage: Codable {
    let width, height: Int
    let url: String
}
