//
//  UICollectionView+Extensions.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 08/06/2022.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        let nib = UINib(nibName: cellType.identifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: cellType.identifier)
    }
}
