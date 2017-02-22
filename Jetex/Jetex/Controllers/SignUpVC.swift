//
//  SignUpVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/15/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import PopupDialog

class SignUpVC: BaseViewController, UITextFieldDelegate, UICheckBoxButtonDelegate {
    
    // MARK: - IBOutlet variables
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var subscriptionCheckBox: UICheckBoxButton!

    
    var emailWarning, passwordWarning, confirmPasswordWarning: WarningForInput!
    
    // MARK: - override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        subscriptionCheckBox.delegate = self
        
        // add warning views
        emailWarning = WarningForInput(setWarning: "Your email is not valid", for: emailTextField, withTitle: emailLabel)
        passwordWarning = WarningForInput(setWarning: "Your password is not valid", for: passwordTextField, withTitle: passwordLabel)
        confirmPasswordWarning = WarningForInput(setWarning: "Your password is not correct", for: confirmPasswordTextField, withTitle: confirmLabel)
    }

    // MARK: - IBActions - sign up
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        guard (emailTextField.text != nil && emailTextField.text!.contains("@")) else {
            //print("email is not right!")
            self.emailWarning.showWarning(animated: true, autoHide: true, after: 10)
            return
        }
            
        guard (passwordTextField.text != nil && passwordTextField.text!.characters.count >= 6) else {
            //print("password 1 is not valid")
            self.passwordWarning.showWarning(animated: true, autoHide: true, after: 10)
            return
        }
            
        guard (confirmPasswordTextField.text != nil && confirmPasswordTextField.text!.characters.count >= 6) else {
            //print("password 2 is not valid")
            self.confirmPasswordWarning.showWarning(animated: true, autoHide: true, after: 10)
            return
        }
            
        guard (passwordTextField.text! == confirmPasswordTextField.text!) else {
            //print("the password are not same")
            self.confirmPasswordWarning.showWarning(animated: true, autoHide: true, after: 10)
            return
        }
        
        // prepare info ready to request
        let userInfo = [
            "email": emailTextField.text!,
            "password": passwordTextField.text!
        ]
        
        // show Popup
        let popup = PopupDialog(title: "Signing Up ...", message: "Please wait!", image: nil)
        self.present(popup, animated: true, completion: nil)
        
        // request to server
        let requestURL = APIURL.JetExAPI.base + APIURL.JetExAPI.signUp
        Alamofire.request(requestURL, method: .post, parameters: userInfo, encoding: JSONEncoding.default).responseJSON { response in
            if let currentUser = response.result.value as? [String: Any]{
                if let _ = currentUser["_id"] as? String {
                if let user = User(JSON: currentUser) {
                    // success get user info
                    let realm = try! Realm()
                    
                    // get the current user, set it to not be
                    let lastUser = realm.objects(User.self).filter("isCurrentUser == true")
                    
                    // update this user is current user
                    user.isCurrentUser = true
                    //print(user)
                    
                    // save it to Realm
                    
                    try! realm.write {
                        if lastUser.count > 0 {
                            lastUser.first?.isCurrentUser = false
                        }
                        
                        realm.add(user, update: true)
                    }
                    
                    if self.subscriptionCheckBox.isChecked == true {
                        // request subscribe status
                        let request = APIURL.JetExAPI.base + APIURL.JetExAPI.createSubscribe
                        
                        let params : [String : Any] = ["listCat": "newsletter",
                                      "email": [
                                        "email_address": user.email,
                                        "status": "subscribed"
                            ]
                        ]
                        
                        Alamofire.request(request, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response(completionHandler: { (response) in
                            if response.error != nil {
                                //print(response.error!)
                            }
                        })
                    }
                    
                    popup.dismiss({
                        let newPopup = PopupDialog(title: "Great", message: "Your account is created!", image: nil)
                        newPopup.addButton(DefaultButton(title: "Continue") {
                            //Remove current view in stack, Go to sign in view, fill the info up
                            if let navController = self.navigationController {
                                let signInVC = SignInVC(nibName: "SignInVC", bundle: nil)
                                
                                var stack = navController.viewControllers
                                stack.remove(at: stack.count - 1)
                                stack.insert(signInVC, at: stack.count)
                                navController.setViewControllers(stack, animated: true)
                            }
                        })
                        self.present(newPopup, animated: true, completion: nil)
                    })
                    }
                } else if let message = currentUser["message"] as? String {
                    popup.dismiss({
                        let newPopup = PopupDialog(title: "Cannot sign up", message: message , image: nil)
                        newPopup.addButton(DefaultButton(title: "Try again", action: nil))
                        self.present(newPopup, animated: true, completion: nil)
                    })
                }
            } else {
                popup.dismiss({
                    let newPopup = PopupDialog(title: "Cannot sign up", message: "Please check your internet connection or your information.", image: nil)
                    newPopup.addButton(DefaultButton(title: "Try again", action: nil))
                    self.present(newPopup, animated: true, completion: nil)
                })
            }
        }
        
//        ProfileVC.isUserLogined = true
//        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- textfield resign
    @IBAction func resignTextField() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            self.confirmPasswordTextField.becomeFirstResponder()
        } else if textField == self.confirmPasswordTextField{
            signUpButtonPressed(textField) // textfield is just a nonsense object here
        }
        return true
    }
    
    func checkboxPressed() {
        resignTextField()
    }
}
