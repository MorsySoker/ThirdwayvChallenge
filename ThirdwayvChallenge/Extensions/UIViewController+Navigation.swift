//
//  UIViewController+Extensions.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 10/06/2022.
//

import UIKit

extension UIViewController {
    
    func pushVC(viewController: UIViewController, hiddenTabBar: Bool = false, completion: (() -> Void)? = nil) {
        if let self =  self as? UINavigationController {
            self.pushViewController(viewController, animated: true)
            return
        }
        if hiddenTabBar {
            viewController.hidesBottomBarWhenPushed = true
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UIViewController {
    
    func createSpinner() -> UIView {
        
        let containerView = UIView(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: view.frame.size.width,
                                                 height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center =  containerView.center
        spinner.startAnimating()
        
        containerView.addSubview(spinner)
        
        return containerView
    }
}
