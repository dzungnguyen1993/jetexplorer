//
//  ChangePasswordVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/17/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseViewController {

    // MARK :- IBOutlet Variables
    @IBOutlet weak var oldPasswordTextField: UIPaddingTextField!
    
    @IBOutlet weak var newPasswordTextField: UIPaddingTextField!
    
    @IBOutlet weak var confirmNewPasswordTextField: UIPaddingTextField!
    
    // MARK: - override functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Save
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
    }
    
    
}
