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
    
    // MARK: - Properties
    
    private var productCellModel: ProductCellViewModel? {
        didSet {
            guard let productCellModel = productCellModel else {
                print("Fail")
                return
            }
            setData(with: productCellModel)
        }
    }
    
    // MARK: - Cell Awake
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    // MARK: - Methods
    
    func configureView(with viewModel: ProductCellViewModel) {
        
        productCellModel = viewModel
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        setBorder()
    }
    
    private func setData(with viewModel: ProductCellViewModel) {
        productImage.downloaded(from: viewModel.image)
        imageHeight.constant = CGFloat(viewModel.imageHeight)
        productPrice.text = "\(viewModel.price)$"
        productDescription.text = viewModel.description
        self.layoutIfNeeded()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.bounds.width, height: 0)
        layoutAttributes.frame.size =
        contentView.systemLayoutSizeFitting(targetSize,
                                            withHorizontalFittingPriority: .required,
                                            verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}
