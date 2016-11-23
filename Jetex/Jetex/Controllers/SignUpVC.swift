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

class SignUpVC: BaseViewController {
    
    // MARK: - IBOutlet variables
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var subscriptionCheckBox: UICheckBoxButton!

    // MARK: - override functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions - sign up
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        guard (emailTextField.text != nil && emailTextField.text!.contains("@")) else {
            print("email is not right!")
            return
        }
            
        guard (passwordTextField.text != nil && passwordTextField.text!.characters.count >= 6) else {
            print("password 1 is not valid")
            return
        }
            
        guard (confirmPasswordTextField.text != nil && confirmPasswordTextField.text!.characters.count >= 6) else {
            print("password 2 is not valid")
            return
        }
            
        guard (passwordTextField.text! == confirmPasswordTextField.text!) else {
            print("the password are not same")
            return
        }
        
        // prepare info ready to request
        let userInfo = [
            "email": emailTextField.text!,
            "password": passwordTextField.text!
        ]
        
        // request to server
        Alamofire.request("https://jetexplorer.com/api/auth/signup", method: .post, parameters: userInfo, encoding: JSONEncoding.default).responseJSON { response in
            if let currentUser = response.result.value as? [String: Any] {
                if let user = User(JSON: currentUser) {
                    // success get user info
                    let realm = try! Realm()
                    
                    // get the current user, set it to not be
                    let lastUser = realm.objects(User.self).filter("isCurrentUser == true")
                    
                    if lastUser.count > 0 {
                        lastUser.first?.isCurrentUser = false
                    }
                    
                    // update this user is current user
                    user.isCurrentUser = true
                    print(user)
                    
                    // save it to Realm
                    
                    try! realm.write {
                        realm.add(user, update: true)
                    }
                    
                    //TODO: Remove current view in stack, Go to sign in view, fill the info up
                    if let navController = self.navigationController {
                        let signInVC = SignInVC(nibName: "SignInVC", bundle: nil)
                        
                        var stack = navController.viewControllers
                        stack.remove(at: stack.count - 1)
                        stack.insert(signInVC, at: stack.count)
                        navController.setViewControllers(stack, animated: true)
                    }
                }
            } else {
                print("Error! Cannot create your account!")
                return
            }
        }
        
//        ProfileVC.isUserLogined = true
//        _ = self.navigationController?.popViewController(animated: true)
    }
}
