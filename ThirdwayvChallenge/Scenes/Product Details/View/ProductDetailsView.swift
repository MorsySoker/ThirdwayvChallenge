//
//  ProductDetailsView.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 10/06/2022.
//

import UIKit

class ProductDetailsView: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var productPrice: UILabel!
    @IBOutlet private weak var productDescription: UILabel!
    @IBOutlet private weak var imageHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    
    private var productDetailsViewModel: ProductCellViewModel? 

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productDescription.frame.origin.y = 0.0
        if let productDetailsViewModel = productDetailsViewModel {
            setData(with: productDetailsViewModel)
        }
    }
    
    // MARK: - Methods
    
    func configureView(with viewModel: ProductCellViewModel) {
        
        productDetailsViewModel = viewModel
    }
    
    private func setData(with viewModel: ProductCellViewModel) {
        
        imageHeight.constant = CGFloat(viewModel.imageHeight)
        productImage.downloaded(from: viewModel.image)
        productPrice.text = "\(viewModel.price)$"
        productDescription.text = viewModel.description
        view.layoutIfNeeded()
    }
}
