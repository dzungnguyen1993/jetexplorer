//
//  SplashVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/26/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift
import PopupDialog
import Alamofire

class SplashVC: UIViewController {

//    // for making animation loading texts
//    var timer: Timer?
//    var animatedIndex = 0
//    let animatedString = ["Downloading information for Countries",
//                          "Downloading information for Cities",
//                          "Downloading information for Airports"]
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.indicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // get list airport
        let defaults = UserDefaults.standard
        let isInstalled = defaults.bool(forKey: "isInstalled")
        
        if (!isInstalled) {
            // Show Loading Pop up view
            
            let loadingVC = InitialLoadingPopupVC(nibName: "InitialLoadingPopupVC", bundle: nil)
            
            let popup = PopupDialog(viewController: loadingVC, buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
            
            self.present(popup, animated: true, completion: nil)
            
//            // to run time async
//            DispatchQueue.global().async {
//                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateMessageForPopup(popup:)), userInfo: popup, repeats: true)
//            }
            
            DispatchQueue.global().sync {
                NetworkManager.shared.requestGetAllAirport { (isSuccess, response) in
                    // fetch list successfully
                    
                    if (isSuccess) {
                        DBManager.shared.parseListAirportJSON(data: response as! NSDictionary)
                        defaults.set(true, forKey: "isInstalled")
                        print("Finish sync")
                        popup.dismiss({
//                            self.timer?.invalidate()
//                            self.timer = nil
                            self.gotoMainScreen()
                        })
                    } else {
                        popup.dismiss({ 
                            self.showAlert(message: "The app needs to connect to the internet to finish installing!", andTitle: "Error")
//                            self.timer?.invalidate()
//                            self.timer = nil
                        })
                    }
                }
            }
        } else {
            self.gotoMainScreen()
        }
    }
    
//    func updateMessageForPopup(popup: PopupDialog) {
//        popup.changeMessage(to: animatedString[animatedIndex], animated: true)
//        animatedIndex += 1
//        if animatedIndex >= animatedString.count {
//            animatedIndex = 0
//        }
//    }
    
    func gotoMainScreen() {
        // check internet connection
        if (Utility.isConnectedToNetwork()) {
            
            // login in silient
            self.loginInsilient()
            
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
    
    func loginInsilient() {
        let request = APIURL.JetExAPI.base + APIURL.JetExAPI.getUserInfo
        Alamofire.request(request).responseObject { (response: DataResponse<User>) in
            if let currentUser = response.result.value {
                print(currentUser)
                // update this user is current user
                currentUser.isCurrentUser = true
                
                // success get user info
                let realm = try! Realm()
                
                // get the current user
                if let lastUser = realm.objects(User.self).filter("isCurrentUser == true").first {
                    if lastUser.id == currentUser.id {
                        // same user login, nothing happen
                    } else {
                        // set it to not be
                        try! realm.write{
                            lastUser.isCurrentUser = false
                        }
                    }
                }
                
                // save/update it to Realm
                try! realm.write {
                    realm.add(currentUser, update: true)
                }
                ProfileVC.isUserLogined = true
            }
        }
    }
}
