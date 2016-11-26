//
//  SplashVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/26/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        // get list airport
        let defaults = UserDefaults.standard
        let isInstalled = defaults.bool(forKey: "isInstalled")
        
        if (!isInstalled) {
            DispatchQueue.global().sync {
                NetworkManager.shared.requestGetAllAirport { (isSuccess, response) in
                    // fetch list successfully
                    if (isSuccess) {
                        DBManager.shared.parseListAirportJSON(data: response as! NSDictionary)
                        defaults.set(true, forKey: "isInstalled")
                        print("Finish sync")
                        
                        self.gotoMainScreen()
                    } else {
                        self.showAlert(message: "The app needs to connect to the internet to finish installing!", andTitle: "Error")
                    }
                }
            }
        }
    }
    
    func gotoMainScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! TabBarController
        self.present(controller, animated: true, completion: nil)
    }
}
