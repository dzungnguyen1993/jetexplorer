//
//  ChangePasswordVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/17/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

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
        
        guard (oldPasswordTextField.text != nil && oldPasswordTextField.text!.characters.count >= 6) else {
            print("password old is not valid")
            return
        }
        
        guard (newPasswordTextField.text != nil && newPasswordTextField.text!.characters.count >= 6) else {
            print("password new is not valid")
            return
        }
        
        guard (newPasswordTextField.text! == confirmNewPasswordTextField.text!) else {
            print("the passwords are not same")
            return
        }
        
        // update info to server
        let newInfo = ["currentPassword": oldPasswordTextField.text!,
                       "newPassword" : newPasswordTextField.text!,
                       "verifyPassword" : confirmNewPasswordTextField.text!]
        
        let requestURL = APIURL.JetExAPI.base + APIURL.JetExAPI.changePassword
        Alamofire.request(requestURL, method: .post, parameters: newInfo, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if let currentUserJSON = response.result.value as? [String: Any] {
                if let message = currentUserJSON["message"] as? String, message.contains("Password changed successfully")   {
                    // update successfully
                    // TODO: show popup? -> back to login
                    ProfileVC.isUserLogined = false
                    // back to setting
                    //                _ = self.navigationController?.popViewController(animated: true)
                    _ = self.navigationController?.popToRootViewController(animated: true)
                } else {
                    print("Cannot change password!")
                    return
                }
            } else {
                print("Wrong info!")
                return
            }
        })
        
    }
}
