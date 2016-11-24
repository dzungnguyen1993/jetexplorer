//
//  BaseViewController.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/8/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var networkErrorView: NetworkErrorView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backNavigationController(_ sender: UIBarButtonItem) {
        self.navigationController!.popViewController(animated: true)
    }
}
