//
//  AppDelegate.swift
//  ThirdwayvChallenge
//
//  Created by MorsyElsokary on 07/06/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setMainInterface()
        
        return true
    }
    
    private func setMainInterface() {
        
        let productsListVC =
        ProductsListView(
            presenter: ProductsListPresenter(
                productsLoader: RemoteWithLocalFallBackFeedLoader(
                    remoteLoader: ProductsListService(),
                    localLoader: ProductsRepository())))
        let navigation = UINavigationController(rootViewController: productsListVC)

        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)

        window!.rootViewController = navigation
        window!.makeKeyAndVisible()
    }
}

