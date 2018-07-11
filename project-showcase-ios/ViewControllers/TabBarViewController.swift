//
//  TabBarViewController.swift
//  project-showcase-ios
//
//  Created by Amanda Ong on 1/19/18.
//  Copyright © 2018 ECAFT. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        addViewControllers()
        
        // UI changes
        self.tabBar.tintColor = UIColor.ecaftRed // Icon color of Active tab
        self.tabBar.unselectedItemTintColor = UIColor.ecaftDarkGray // Icon color of Inactive tab
        // Change tab bar text color
        let unselectedItem = [NSAttributedStringKey.foregroundColor: UIColor.ecaftDarkGray]
        let selectedItem = [NSAttributedStringKey.foregroundColor: UIColor.ecaftRed]
        for viewController in self.viewControllers! {
            viewController.tabBarItem.setTitleTextAttributes(unselectedItem, for: .normal)
            viewController.tabBarItem.setTitleTextAttributes(selectedItem, for: .selected)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func addViewControllers() {
        let teamViewModel = TeamViewModel()
        
        let browseVC = BrowseViewController()
        let browseBarItem = UITabBarItem(title: "Browse", image: #imageLiteral(resourceName: "list"), selectedImage: #imageLiteral(resourceName: "listRed"))
        browseVC.tabBarItem = browseBarItem
        browseVC.teamViewModel = teamViewModel
        
        let listVC = ListViewController()
        let listBarItem = UITabBarItem(title: "My List", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "homeRed"))
        listVC.tabBarItem = listBarItem
        listVC.teamViewModel = teamViewModel
        
        let mapVC = MapViewController()
        mapVC.teamViewModel = teamViewModel
        let mapBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "map"), selectedImage: #imageLiteral(resourceName: "mapRed"))
        mapVC.tabBarItem = mapBarItem
        
        
        let controllers = [browseVC, listVC, mapVC]
        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
        
    }
}
