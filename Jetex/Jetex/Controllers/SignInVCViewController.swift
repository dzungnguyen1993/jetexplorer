//
//  SignInVCViewController.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/15/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class SignInVC: BaseViewController {

    // MARK: - IBOutlet Variables
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // get the last user info to fill up
        let realm = try! Realm()
        if let lastUser = realm.objects(User.self).filter("isCurrentUser == true").first {
            emailTextField.text = lastUser.email
            passwordTextField.becomeFirstResponder()
        } else {
            emailTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - Sign In
    @IBAction func signInButtonPressed(_ sender: AnyObject) {
        guard (emailTextField.text != nil && emailTextField.text!.contains("@")) else {
            print("email is not right!")
            return
        }
        
        guard (passwordTextField.text != nil && passwordTextField.text!.characters.count >= 6) else {
            print("password is not valid")
            return
        }
        
        // prepare info ready to request
        let userInfo = [
            "email": emailTextField.text!,
            "password": passwordTextField.text!
        ]
        
        // request to server
        Alamofire.request("https://jetexplorer.com/api/auth/signin", method: .post, parameters: userInfo, encoding: JSONEncoding.default).responseJSON { response in
            if let currentUser = response.result.value as? [String: Any] {
                if let user = User(JSON: currentUser) {
                    print(user)
                    // success get user info
                    let realm = try! Realm()
                
                    func updateCurrentUser () {
                        // update this user is current user
                        user.isCurrentUser = true
                        // save/update it to Realm
                        try! realm.write {
                            realm.add(user, update: true)
                        }
                    }
                    
                    // get the current user
                    if let lastUser = realm.objects(User.self).filter("isCurrentUser == true").first {
                        if lastUser.id == user.id {
                            // same user login, nothing happen
                        } else {
                            // set it to not be
                            try! realm.write{
                                lastUser.isCurrentUser = false
                            }
                            updateCurrentUser()
                        }
                    } else {
                        updateCurrentUser()
                    }
                    
                    // back to previous screen
                    ProfileVC.isUserLogined = true
                    _ = self.navigationController?.popViewController(animated: true)
                }
            } else {
                print("Wrong info!")
                return
            }
        }
        
    }
    
    @IBAction func forgetButtonPressed(_ sender: AnyObject) {
        let vc = ForgotPasswordVC(nibName: "ForgotPasswordVC", bundle: nil)
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
}
