//
//  UIView+Extensions.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 07/06/2022.
//

import UIKit

extension UIView {
    
    func setBorder(borderWidth: CGFloat = 0.7,
                   color: UIColor = .darkGray) {
        layer.borderColor = color.cgColor
        layer.borderWidth = borderWidth
    }
    
    // MARK: - Nib Identifier
    // Note: The Nib Assigned name must match it's class ViewModel
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}
