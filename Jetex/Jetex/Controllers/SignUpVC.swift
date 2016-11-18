//
//  SignUpVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/15/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class SignUpVC: BaseViewController {
    
    // MARK: - IBOutlet variables
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var subscriptionCheckBox: UICheckBoxButton!

    // MARK: - override functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - IBActions - sign up
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        
    }
}
