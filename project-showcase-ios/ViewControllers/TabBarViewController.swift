//
//  TabBarViewController.swift
//  project-showcase-ios
//
//  Created by Amanda Ong on 1/19/18.
//  Copyright © 2018 ECAFT. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var allTeamsList: [Team] = []
    var favoriteList: [Team] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTempTeamList()
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
    
    //hard coded
    private func setupTempTeamList() {
        let contact = Contact(name: "Claire", major: "ORIE", gradYear: "2017", email: "ab123@cornell.edu")
        let t1 = Team(teamName: "A", type: "Meng", department: "CS", descrip: "a", contacts: [contact])
        let t2 = Team(teamName: "B", type: "proj", department: "MAE", descrip: "b", contacts: [contact])
        let t3 = Team(teamName: "C", type: "Meng", department: "ORIE", descrip: "c", contacts: [contact])
        
        allTeamsList.append(t1)
        allTeamsList.append(t2)
        allTeamsList.append(t3)
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
        browseVC.allTeamsList = allTeamsList

        
        let listVC = ListViewController()
        let listBarItem = UITabBarItem(title: "My List", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "homeRed"))
        listVC.tabBarItem = listBarItem
        listVC.teamViewModel = teamViewModel
        listVC.allTeamsList = allTeamsList

        
        let mapVC = MapViewController()
        let mapBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "map"), selectedImage: #imageLiteral(resourceName: "mapRed"))
        mapVC.tabBarItem = mapBarItem
        //mapVC.teamViewModel = teamViewModel

        let controllers = [browseVC, listVC, mapVC]
        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
        
    }
}
