//
//  TabBarController.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/8/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewControllers = [UIViewController]()
        self.addTabFlight()
        self.addTabProfile()
    }

    // MARK: Tab Flight
    func addTabFlight() {
        let vc = FlightSearchVC(nibName: "FlightSearchVC", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        
        viewControllers?.append(nav)
        nav.tabBarItem = UITabBarItem(title: "Flight", image: UIImage(), tag: 1)
    }
    
    // MARK: - Tab Profile
    func addTabProfile() {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        
        viewControllers?.append(nav)
        nav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(), tag: 2)
    }
}
