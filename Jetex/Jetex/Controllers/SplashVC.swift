//
//  SplashVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/26/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import PopupDialog

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
            // Show Loading Pop up view
            let popup = PopupDialog(title: "Downloading initial data ...", message: "Only for the first time. Please wait!", image: UIImage(named: "loading.jpg"), buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
            
            self.present(popup, animated: true, completion: nil)
            
            DispatchQueue.global().sync {
                NetworkManager.shared.requestGetAllAirport { (isSuccess, response) in
                    // fetch list successfully
                    
                    if (isSuccess) {
                        DBManager.shared.parseListAirportJSON(data: response as! NSDictionary)
                        defaults.set(true, forKey: "isInstalled")
                        print("Finish sync")
                        popup.dismiss({
                            self.gotoMainScreen()
                        })
                    } else {
                        popup.dismiss({ 
                            self.showAlert(message: "The app needs to connect to the internet to finish installing!", andTitle: "Error")
                        })
                    }
                }
            }
        } else {
            self.gotoMainScreen()
        }
    }
    
    func gotoMainScreen() {
        // check internet connection
        if (Utility.isConnectedToNetwork()) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! TabBarController
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        } else {
            let vc = NetworkErrorVC(nibName: "NetworkErrorVC", bundle: nil)
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
}
