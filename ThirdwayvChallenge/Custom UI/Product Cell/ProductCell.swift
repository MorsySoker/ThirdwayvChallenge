//
//  ProductCell.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 07/06/2022.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var productPrice: UILabel!
    @IBOutlet private weak var productDescription: UILabel!
    
    @IBOutlet private weak var imageHeight: NSLayoutConstraint!
    
    // MARK: - Cell Awake
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupView()
    }
    
    // MARK: - Methods
    
    func configureView(with height: CGFloat) {
        
        imageHeight.constant = height
        self.layoutIfNeeded()
    }

    // MARK: - Private Methods
    
    private func setupView() {
        
        productImage.image = UIImage(named: "stockImage")
        setBorder()
    }
}
