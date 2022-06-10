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
