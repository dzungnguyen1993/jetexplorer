//
//  TabBarController.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/8/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        
        viewControllers = [UIViewController]()
        self.addTabFlight()
        self.addTabHotel()
        self.addTabHistory()
        self.addTabProfile()
    }

    // MARK: Tab Flight
    func addTabFlight() {
        let vc = FlightSearchVC(nibName: "FlightSearchVC", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        
        viewControllers?.append(nav)

        nav.tabBarItem = UITabBarItem(title: "Flights", image: UIImage.generateTabBarImageFromHex(fromHex: JetExFontHexCode.planeEmpty.rawValue), tag: 1)
        
        nav.tabBarItem.selectedImage = UIImage.generateTabBarImageFromHex(fromHex: JetExFontHexCode.planeFulfill.rawValue)
        
        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(hex: 0x706F73), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!], for: .normal)
        
        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(hex: 0x674290), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!], for: .selected)
    }
    
    // MARK: - Tab Hotel
    func addTabHotel() {
        let vc = HotelSearchVC(nibName: "HotelSearchVC", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        
        viewControllers?.append(nav)
        
        nav.tabBarItem = UITabBarItem(title: "Hotels", image: UIImage.generateTabBarImageFromHex(fromHex: JetExFontHexCode.bedEmpty.rawValue), tag: 1)
        
        nav.tabBarItem.selectedImage = UIImage.generateTabBarImageFromHex(fromHex: JetExFontHexCode.bedFulfill.rawValue)
        
        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(hex: 0x706F73), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!], for: .normal)
        
        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(hex: 0x674290), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!], for: .selected)
    }
    
    // MARK: - Tab History
    func addTabHistory() {
        let vc = SearchHistoryVC(nibName: "SearchHistoryVC", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        
        viewControllers?.append(nav)
        nav.tabBarItem = UITabBarItem(title: "Searches", image: UIImage.generateTabBarImageFromHex(fromHex: JetExFontHexCode.historyEmpty.rawValue), tag: 2)
        
        nav.tabBarItem.selectedImage = UIImage.generateTabBarImageFromHex(fromHex: JetExFontHexCode.historyFulfill.rawValue)
        
        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(hex: 0x706F73), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!], for: .normal)
        
        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(hex: 0x674290), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!], for: .selected)
    }

    
    // MARK: - Tab Profile
    func addTabProfile() {
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        
        viewControllers?.append(nav)
        nav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage.generateTabBarImageFromHex(fromHex: JetExFontHexCode.profileEmpty.rawValue), tag: 2)
        
        nav.tabBarItem.selectedImage = UIImage.generateTabBarImageFromHex(fromHex: JetExFontHexCode.profileFulfill.rawValue)
        
        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(hex: 0x706F73), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!], for: .normal)
        
        nav.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(hex: 0x674290), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!], for: .selected)
    }
    
    // MARK: - Animated Transition
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let tabViewControllers = tabBarController.viewControllers!
        guard let toIndex = tabViewControllers.index(of: viewController) else {
            return false
        }
        
        // Our method
        animateToTab(toIndex: toIndex)
        return true
    }
    
    func animateToTab(toIndex: Int, needResetToRootView: Bool = false, completion: ((UIViewController) -> Void)? = nil) {
        let tabViewControllers = viewControllers!
        let fromView = selectedViewController!.view!
        let toView = tabViewControllers[toIndex].view!
        let fromIndex = tabViewControllers.index(of: selectedViewController!)
        
        guard fromIndex != toIndex else {return}
        
        // Add the toView to the tab bar view
        fromView.superview!.addSubview(toView)
        
        // Position toView off screen (to the left/right of fromView)
        let screenWidth = UIScreen.main.bounds.size.width;
        let scrollRight = toIndex > fromIndex!;
        let offset = (scrollRight ? screenWidth : -screenWidth)
        toView.center = CGPoint(x: fromView.center.x + offset, y: toView.center.y)
        
        // Disable interaction during animation
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            // Slide the views by -offset
            fromView.center = CGPoint(x: fromView.center.x - offset, y: fromView.center.y);
            toView.center   = CGPoint(x: toView.center.x - offset, y: toView.center.y);
            
            if needResetToRootView {
                _ = (tabViewControllers[toIndex] as! UINavigationController).popToRootViewController(animated: true)
            }
            
        }, completion: { finished in
            
            // Remove the old view from the tabbar view.
            fromView.removeFromSuperview()
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
            
            if let completion = completion {
                let vc = (tabViewControllers[self.selectedIndex] as! UINavigationController).viewControllers.first!
                completion(vc)
            }
        })
    }

}
