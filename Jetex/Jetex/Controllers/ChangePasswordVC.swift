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
import PopupDialog

class ChangePasswordVC: BaseViewController {

    // MARK :- IBOutlet Variables
    
    @IBOutlet weak var oldPasswordLabel: UILabel!
    @IBOutlet weak var oldPasswordTextField: UIPaddingTextField!
    
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UIPaddingTextField!
    
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmNewPasswordTextField: UIPaddingTextField!
    
    // for warnings
    var oldPasswordWarning, newPasswordWarning, confirmNewPasswordWarning: WarningForInput!
    
    // MARK: - override functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // add the warning
        oldPasswordWarning = WarningForInput(setWarning: "Your password is not correct", for: oldPasswordTextField, withTitle: oldPasswordLabel)
        newPasswordWarning = WarningForInput(setWarning: "New password is not valid", for: newPasswordTextField, withTitle: newPasswordLabel)
        confirmNewPasswordWarning = WarningForInput(setWarning: "Your confirm password is not valid", for: confirmNewPasswordTextField, withTitle: confirmPasswordLabel)
    }
    
    // MARK: - Save
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        
        guard (oldPasswordTextField.text != nil && oldPasswordTextField.text!.characters.count >= 6) else {
            print("password old is not valid")
            self.oldPasswordWarning.showWarning(animated: true, autoHide: true, after: 5)
            return
        }
        
        guard (newPasswordTextField.text != nil && newPasswordTextField.text!.characters.count >= 6) else {
            print("password new is not valid")
            self.newPasswordWarning.showWarning(animated: true, autoHide: true, after: 5)
            return
        }
        
        guard (newPasswordTextField.text! == confirmNewPasswordTextField.text!) else {
            print("the passwords are not same")
            self.confirmNewPasswordWarning.showWarning(animated: true, autoHide: true, after: 5)
            return
        }
        
        // Show Loading Pop up view
        let popup = PopupDialog(title: "Updating...", message: "Please wait!", image: UIImage(named: "loading.jpg"), buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
        
        self.present(popup, animated: true, completion: nil)
        
        // update info to server
        let newInfo = ["currentPassword": oldPasswordTextField.text!,
                       "newPassword" : newPasswordTextField.text!,
                       "verifyPassword" : confirmNewPasswordTextField.text!]
        
        let requestURL = APIURL.JetExAPI.base + APIURL.JetExAPI.changePassword
        Alamofire.request(requestURL, method: .post, parameters: newInfo, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if let currentUserJSON = response.result.value as? [String: Any] {
                if let message = currentUserJSON["message"] as? String, message.contains("Password changed successfully")   {
                    // update successfully
                    popup.dismiss({
                        let newPopup = PopupDialog(title: "Updated!", message: "Your password is changed", image: UIImage(named: "loading.jpg"))
                        newPopup.addButton(DefaultButton(title: "Sign In") {
                            ProfileVC.isUserLogined = false
                            //Remove 2 current views in stack, Go to sign in view, fill the info up
                            if let navController = self.navigationController {
                                let signInVC = SignInVC(nibName: "SignInVC", bundle: nil)
                                
                                var stack = navController.viewControllers
                                stack.remove(at: stack.count - 1)
                                stack.remove(at: stack.count - 1)
                                stack.insert(signInVC, at: stack.count)
                                navController.setViewControllers(stack, animated: true)
                            }
                        })
                        self.present(newPopup, animated: true, completion: nil)
                    })
                    
                } else {
                    popup.dismiss({
                        let newPopup = PopupDialog(title: "Cannot change password", message: "Please check your internet connection or your information.", image: UIImage(named: "loading.jpg"))
                        newPopup.addButton(CancelButton(title: "Try again", action: nil))
                        self.present(newPopup, animated: true, completion: nil)
                    })
                }
            } else {
                popup.dismiss({
                    let newPopup = PopupDialog(title: "Cannot change password", message: "Please check your internet connection or your information.", image: UIImage(named: "loading.jpg"))
                    newPopup.addButton(CancelButton(title: "Try again", action: nil))
                    self.present(newPopup, animated: true, completion: nil)
                })
            }
        })
        
    }
}
