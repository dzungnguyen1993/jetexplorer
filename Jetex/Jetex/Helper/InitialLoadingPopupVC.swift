//
//  InitialLoadingPopupVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 12/29/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class InitialLoadingPopupVC: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var willBeTitle: String?
    var willBeMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let title = self.willBeTitle {
            self.titleLabel.text = title
        }
        if let message = self.willBeMessage {
            self.messageLabel.text = message
        }
    }
    
    func initView(title: String, message: String)  {
        self.willBeTitle = title
        self.willBeMessage = message
    }
}
