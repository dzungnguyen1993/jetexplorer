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
        self.addTabHistory()
        self.addTabProfile()
    }

    // MARK: Tab Flight
    func addTabFlight() {
        let vc = FlightSearchVC(nibName: "FlightSearchVC", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        
        viewControllers?.append(nav)
        nav.tabBarItem = UITabBarItem(title: "Flights", image: UIImage.generateTabBarImageFromHex(fromHex: JetExFontHexCode.plane.rawValue), tag: 1)
        
        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(hex: 0x706F73), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!], for: .normal)
        
        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(hex: 0x674290), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!], for: .selected)
    }
    
    // MARK: - Tab History
    func addTabHistory() {
        let vc = SearchHistoryVC(nibName: "SearchHistoryVC", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        
        viewControllers?.append(nav)
        nav.tabBarItem = UITabBarItem(title: "Searches", image: UIImage.generateTabBarImageFromHex(fromHex: JetExFontHexCode.history.rawValue), tag: 2)
        
        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(hex: 0x706F73), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!], for: .normal)
        
        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(hex: 0x674290), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!], for: .selected)
    }

    
    // MARK: - Tab Profile
    func addTabProfile() {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        
        viewControllers?.append(nav)
        nav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage.generateTabBarImageFromHex(fromHex: JetExFontHexCode.userCircle.rawValue), tag: 2)
        
        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(hex: 0x706F73), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!], for: .normal)
        
        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(hex: 0x674290), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!], for: .selected)
    }
}
