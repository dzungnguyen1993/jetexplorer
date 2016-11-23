//
//  ForgotPasswordVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/17/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

class ForgotPasswordVC: BaseViewController {

    // MARK: - IBOutlet variables
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let realm = try! Realm()
        if let lastUser = realm.objects(User.self).filter("isCurrentUser == true").first {
            emailTextField.text = lastUser.email
        } else {
            emailTextField.becomeFirstResponder()
        }
    }
    
    // MARK:- send
    @IBAction func sendButtonPressed(_ sender: AnyObject) {
        // request server to send email reseting password
        
        // back to setting
        _ = self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
