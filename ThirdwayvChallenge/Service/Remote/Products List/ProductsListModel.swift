//
//  ProductsListModel.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 09/06/2022.
//

import Foundation

// MARK: - ProductsListModel
public struct ProductsListModel: Codable {
    let id: Int?
    let productDescription: String?
    let image: ProductImage?
    let price: Int?
    
    // MARK: - To ViewModel
    
    func toProductCellViewModel() -> ProductCellViewModel? {
        guard let productDescription = productDescription,
              let image = image,
              let imageURL = image.url,
              let imageHeight = image.height,
              let price = price  else {
            return nil
        }
        
        
        return ProductCellViewModel(image: imageURL,
                                    imageHeight: imageHeight,
                                    price: price,
                                    description: productDescription)
    }
}

// MARK: - ProductImage
public struct ProductImage: Codable {
    let width, height: Int?
    let url: String?
}
