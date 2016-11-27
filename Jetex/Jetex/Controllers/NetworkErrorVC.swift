//
//  NetworkErrorVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/27/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class NetworkErrorVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func retry(_ sender: Any) {
        if (Utility.isConnectedToNetwork()) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! TabBarController
            controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        }
    }
}
