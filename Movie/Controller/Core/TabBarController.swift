//
//  TabBarController.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 03.10.23.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let homeVC = HomeViewController()
    private let searchVC = SearchViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarAppearance = UINavigationBar.appearance()
        let tabBarAppearance = UITabBar.appearance()
        navigationBarAppearance.tintColor = .label
        navigationBarAppearance.prefersLargeTitles = false
        tabBarAppearance.tintColor = .label
        
        homeVC.title = "Home"
        let homeNavVC = UINavigationController(rootViewController: homeVC)
        let searchNavVC = UINavigationController(rootViewController: searchVC)
        homeNavVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        searchNavVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        setViewControllers([homeNavVC, searchNavVC], animated: false)
    }
    
}
