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
import PopupDialog

class SignInVC: BaseViewController {

    // MARK: - IBOutlet Variables
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var emailWarning, passwordWarning: WarningForInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // add the warning 
        emailWarning = WarningForInput(setWarning: "Your email is not correct", for: emailTextField, withTitle: emailLabel)
        passwordWarning = WarningForInput(setWarning: "Your password is not correct", for: passwordTextField, withTitle: passwordLabel)
        
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
            self.emailWarning.showWarning(animated: true, autoHide: true, after: 5)
            return
        }
        
        guard (passwordTextField.text != nil && passwordTextField.text!.characters.count >= 6) else {
            print("password is not valid")
            self.passwordWarning.showWarning(animated: true, autoHide: true, after: 5)
            return
        }
        
        // prepare info ready to request
        let userInfo = [
            "email": emailTextField.text!,
            "password": passwordTextField.text!
        ]
        
        // Show Loading Pop up view
        let popup = PopupDialog(title: "Signing In ...", message: "Please wait!", image: nil, buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
        
        self.present(popup, animated: true, completion: nil)
        
        // TOTO: check if user are offline, then get offline information
        
        // request to server
        let requestURL = APIURL.JetExAPI.base + APIURL.JetExAPI.signIn
        Alamofire.request(requestURL, method: .post, parameters: userInfo, encoding: JSONEncoding.default).responseJSON { response in
            if let value = response.result.value as? NSDictionary {
                if let id = value.value(forKey: "_id") as? String, id != "" {
                    if let user = User(JSON: value as! [String: Any]) {
                        print(user)
                        // update this user is current user
                        user.isCurrentUser = true
                        
                        // success get user info
                        let realm = try! Realm()
                        
                        func updateCurrentUser () {
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
                        
                        popup.dismiss({
                            // back to previous screen
                            ProfileVC.isUserLogined = true
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                        return
                    }
                } else if let message = value.value(forKey: "message") as? String {
                    // hide pop up
                    print(message)
                    popup.dismiss()
                    
                    // Show notification
                    self.emailWarning.showWarning(animated: true, autoHide: true, after: 5)
                    self.passwordWarning.showWarning(animated: true, autoHide: true, after: 5)
                }
            } else {
                popup.dismiss({
                    let newPopup = PopupDialog(title: "Cannot sign in", message: "Please check your internet connection or your information.", image: nil)
                    newPopup.addButton(DefaultButton(title: "Try again", action: nil))
                    self.present(newPopup, animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func forgetButtonPressed(_ sender: AnyObject) {
        let vc = ForgotPasswordVC(nibName: "ForgotPasswordVC", bundle: nil)
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
}
