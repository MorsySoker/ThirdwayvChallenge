//
//  ProductsListView.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 07/06/2022.
//

import UIKit

class ProductsListView: UIViewController {
    
    // MARK: - OutLets
    
    @IBOutlet private weak var productsListCollection: UICollectionView!
    
    //MARK: Properties
    
    private var presenter: ProductsListPresenter?
    
    private var products: [ProductsListModel]?
    
    // MARK: - init
    
    init(service: ProductsListServiceProtocol) {
        
        self.presenter = ProductsListPresenter(serviceManager: service)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Products List"
        
        setupProductsListCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let presenter = presenter else {
            return
        }
        presenter.setViewDelegate(delegate: self)
        presenter.fetchProducts()
    }
    
    // MARK: - Methods
    
    private func setupProductsListCollection() {
        
        let customFlowLayout = CustomFlowLayout()
        
        customFlowLayout.sectionInsetReference = .fromContentInset
        customFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        customFlowLayout.minimumInteritemSpacing = 0
        customFlowLayout.minimumLineSpacing = 0
        customFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        productsListCollection.collectionViewLayout = customFlowLayout
        productsListCollection.contentInsetAdjustmentBehavior = .always
        productsListCollection.register(cellType: ProductCell.self)
        
        productsListCollection.dataSource = self
        productsListCollection.delegate = self
        
        reloadProductsListCollection()
    }
    
    private func reloadProductsListCollection() {
        DispatchQueue.main.async {
            self.productsListCollection.reloadData()
        }
    }
}

// MARK: - Presenter Delegate

extension ProductsListView: ProductsListPresenterViewDelegate {
    
    func showProducts(products: [ProductsListModel]) {
        self.products = products
        reloadProductsListCollection()
    }
    
    func showError(msg: String) {
        print(msg)
    }
}

// MARK: - Collection Delegate

extension ProductsListView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Hey \(indexPath.row)")
    }
}

// MARK: - Collection DataSource

extension ProductsListView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let productCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCell.identifier,
            for: indexPath) as? ProductCell else {
            fatalError("xib doesn't exist")
        }
        
        guard let products = products else {
            print("Products Not Found")
            return productCell
        }
        
        let product = products[indexPath.row]
        
        if let productViewModel = product.toProductCellViewModel() {
            
            productCell.configureView(with: productViewModel)
        }
        
        return productCell
    }
}

// MARK: - Collection Delegate FlowLayout

extension ProductsListView: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        CGSize(width: collectionView.bounds.width / 2,
//               height: 500)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return .zero
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return .zero
//    }
}

final class CustomFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects =
        super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
        
        layoutAttributesObjects?.forEach({ layoutAttributes in
            if layoutAttributes.representedElementCategory == .cell {
                if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                    layoutAttributes.frame = newFrame
                }
            }
        })
        
        // Constants
         let leftPadding: CGFloat = 8
         let interItemSpacing = minimumInteritemSpacing
         
         // Tracking values
         var leftMargin: CGFloat = leftPadding // Modified to determine origin.x for each item
         var maxY: CGFloat = -1.0 // Modified to determine origin.y for each item
         var rowSizes: [[CGFloat]] = [] // Tracks the starting and ending x-values for the first and last item in the row
         var currentRow: Int = 0 // Tracks the current row
        layoutAttributesObjects?.forEach { layoutAttribute in
             
             // Each layoutAttribute represents its own item
             if layoutAttribute.frame.origin.y >= maxY {
                 
                 // This layoutAttribute represents the left-most item in the row
                 leftMargin = leftPadding
                 
                 // Register its origin.x in rowSizes for use later
                 if rowSizes.count == 0 {
                     // Add to first row
                     rowSizes = [[leftMargin, 0]]
                 } else {
                     // Append a new row
                     rowSizes.append([leftMargin, 0])
                     currentRow += 1
                 }
             }
             
             layoutAttribute.frame.origin.x = leftMargin
             
             leftMargin += layoutAttribute.frame.width + interItemSpacing
             maxY = max(layoutAttribute.frame.maxY, maxY)
             
             // Add right-most x value for last item in the row
             rowSizes[currentRow][1] = leftMargin - interItemSpacing
         }
         
         // At this point, all cells are left aligned
         // Reset tracking values and add extra left padding to center align entire row
         leftMargin = leftPadding
         maxY = -1.0
         currentRow = 0
        layoutAttributesObjects?.forEach { layoutAttribute in
             
             // Each layoutAttribute is its own item
             if layoutAttribute.frame.origin.y >= maxY {
                 
                 // This layoutAttribute represents the left-most item in the row
                 leftMargin = leftPadding
                 
                 // Need to bump it up by an appended margin
                 let rowWidth = rowSizes[currentRow][1] - rowSizes[currentRow][0] // last.x - first.x
                 let appendedMargin = (collectionView!.frame.width - leftPadding  - rowWidth - leftPadding) / 2
                 leftMargin += appendedMargin
                 
                 currentRow += 1
             }
             
             layoutAttribute.frame.origin.x = leftMargin
             
             leftMargin += layoutAttribute.frame.width + interItemSpacing
             maxY = max(layoutAttribute.frame.maxY, maxY)
         }
        
        return layoutAttributesObjects
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            fatalError()
        }
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }

        
        //layoutAttributes.frame.origin.x = sectionInset.left

        layoutAttributes.frame.size.width = (collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right) / 2
        return layoutAttributes
    }

}


// NOTE: Doesn't work for horizontal layout!
//class CenterAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        guard let superAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
//        // Copy each item to prevent "UICollectionViewFlowLayout has cached frame mismatch" warning
//        guard let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
//
//        // Constants
//        let leftPadding: CGFloat = 8
//        let interItemSpacing = minimumInteritemSpacing
//
//        // Tracking values
//        var leftMargin: CGFloat = leftPadding // Modified to determine origin.x for each item
//        var maxY: CGFloat = -1.0 // Modified to determine origin.y for each item
//        var rowSizes: [[CGFloat]] = [] // Tracks the starting and ending x-values for the first and last item in the row
//        var currentRow: Int = 0 // Tracks the current row
//        attributes.forEach { layoutAttribute in
//
//            // Each layoutAttribute represents its own item
//            if layoutAttribute.frame.origin.y >= maxY {
//
//                // This layoutAttribute represents the left-most item in the row
//                leftMargin = leftPadding
//
//                // Register its origin.x in rowSizes for use later
//                if rowSizes.count == 0 {
//                    // Add to first row
//                    rowSizes = [[leftMargin, 0]]
//                } else {
//                    // Append a new row
//                    rowSizes.append([leftMargin, 0])
//                    currentRow += 1
//                }
//            }
//
//            layoutAttribute.frame.origin.x = leftMargin
//
//            leftMargin += layoutAttribute.frame.width + interItemSpacing
//            maxY = max(layoutAttribute.frame.maxY, maxY)
//
//            // Add right-most x value for last item in the row
//            rowSizes[currentRow][1] = leftMargin - interItemSpacing
//        }
//
//        // At this point, all cells are left aligned
//        // Reset tracking values and add extra left padding to center align entire row
//        leftMargin = leftPadding
//        maxY = -1.0
//        currentRow = 0
//        attributes.forEach { layoutAttribute in
//
//            // Each layoutAttribute is its own item
//            if layoutAttribute.frame.origin.y >= maxY {
//
//                // This layoutAttribute represents the left-most item in the row
//                leftMargin = leftPadding
//
//                // Need to bump it up by an appended margin
//                let rowWidth = rowSizes[currentRow][1] - rowSizes[currentRow][0] // last.x - first.x
//                let appendedMargin = (collectionView!.frame.width - leftPadding  - rowWidth - leftPadding) / 2
//                leftMargin += appendedMargin
//
//                currentRow += 1
//            }
//
//            layoutAttribute.frame.origin.x = leftMargin
//
//            leftMargin += layoutAttribute.frame.width + interItemSpacing
//            maxY = max(layoutAttribute.frame.maxY, maxY)
//        }
//
//        return attributes
//    }
//}
