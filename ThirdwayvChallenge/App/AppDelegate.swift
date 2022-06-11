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

        reachable(with: "www.google.com")
        
        let productsListVC = ProductsListView(service: ProductsListService())
        let navigation = UINavigationController(rootViewController: productsListVC)

        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)

        window!.rootViewController = navigation
        window!.makeKeyAndVisible()
        
        return true
    }
    
    private func reachable(with hostName: String) {
        do {
            try Network.reachability = Reachability(hostname: hostName)
        }
        catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                print("Network error:\nFailed to create reachability object With host named:", hostname)
            case let .failedToInitializeWith(address)?:
                print("Network error:\nFailed to initialize reachability object With address:", address)
            case .failedToSetCallout?:
                print("Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                print("Network error:\nFailed to set DispatchQueue")
            case .none:
                print(error)
            }
        }
    }
}

