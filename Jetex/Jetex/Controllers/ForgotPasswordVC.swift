//
//  ForgotPasswordVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/17/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift
import PopupDialog
import Alamofire

class ForgotPasswordVC: BaseViewController {

    // MARK: - IBOutlet variables
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    var emailWarning: WarningForInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let realm = try! Realm()
        if let lastUser = realm.objects(User.self).filter("isCurrentUser == true").first {
            emailTextField.text = lastUser.email
        } else {
            emailTextField.becomeFirstResponder()
        }
        
        emailWarning = WarningForInput(setWarning: "Your email is not correct", for: emailTextField, withTitle: emailLabel)
    }
    
    // MARK:- send
    @IBAction func sendButtonPressed(_ sender: AnyObject) {
        guard (emailTextField.text != nil && emailTextField.text!.contains("@")) else {
            print("email is not right!")
            self.emailWarning.showWarning(animated: true, autoHide: true, after: 5)
            return
        }
        
        // TODO: request server to send email reseting password
        let request = APIURL.JetExAPI.base + APIURL.JetExAPI.forgotPassword
        Alamofire.request(request, method: .post, parameters: ["email" : emailTextField.text!], encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let value = response.result.value as? [String: Any], let message = value["message"] as? String {
                    // Show Loading Pop up view
                    let popup = PopupDialog(title: "Go check your inbox", message: message, image: nil)
                    
                    popup.addButton(DefaultButton(title: "Done") {
                        // back to setting
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    
                    self.present(popup, animated: true, completion: nil)
                    return
                }
            }
            // error
            // Show Loading Pop up view
            let popup = PopupDialog(title: "Cannot reset your password", message: "Please check your information/internet connection.", image: nil)
            popup.addButton(DefaultButton(title: "Try again") {
            })
            self.present(popup, animated: true, completion: nil)
        }
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
