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
    private let profileVC = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupViewControllers()
    }
    
    //MARK: setup tab bar and navigation bar appearences
    private func setupAppearance() {
        UINavigationBar.appearance().tintColor = .label
        UINavigationBar.appearance().prefersLargeTitles = false

        UITabBar.appearance().tintColor = .label
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
    private func setupViewControllers() {
         homeVC.title = "Home"
         searchVC.title = "Search"
         profileVC.title = "Profile"

         let homeNavVC = UINavigationController(rootViewController: homeVC)
         let searchNavVC = UINavigationController(rootViewController: searchVC)
         let profileNavVC = UINavigationController(rootViewController: profileVC)

         homeNavVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
         searchNavVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
         profileNavVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)

         setViewControllers([homeNavVC, searchNavVC, profileNavVC], animated: false)
     }
    
}
