//
//  ChangNameVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/16/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import PopupDialog

class ChangNameVC: BaseViewController {
    
    // MARK: - IBOutlet Variables
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UIPaddingTextField!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UIPaddingTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let realm = try! Realm()
        if let currentUser = realm.objects(User.self).filter("isCurrentUser == true").first {
        
            firstNameTextField.text = currentUser.firstName
            lastNameTextField.text = currentUser.lastName
            
        }
    }
    
    // MARK: - Save
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        guard (firstNameTextField.text != nil && lastNameTextField.text != nil) else {
            return
        }
        
        // block the view
        self.view.isUserInteractionEnabled = false
        
        // update info to db
        let realm = try! Realm()
        if let currentUser = realm.objects(User.self).filter("isCurrentUser == true").first {
            try! realm.write {
                currentUser.firstName = firstNameTextField.text!
                currentUser.lastName = lastNameTextField.text!
                currentUser.displayName = "\(firstNameTextField.text!) \(lastNameTextField.text!)"
            }
        
            // update info to server
            let newInfo = ["email": currentUser.email,
                           "firstName" : currentUser.firstName!,
                           "lastName" : currentUser.lastName!]
        
            let requestURL = APIURL.JetExAPI.base + APIURL.JetExAPI.updateUserData
            Alamofire.request(requestURL, method: .put, parameters: newInfo, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if let _ = response.result.value as? [String: Any] {
                    // update successfully
                    
                    let newPopup = PopupDialog(title: "Updated!", message: "Now you are \(self.firstNameTextField.text!) \(self.lastNameTextField.text!)", image: nil)
                        newPopup.addButton(DefaultButton(title: "Done", action: {
                            // back to setting
                            _ = self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(newPopup, animated: true, completion: nil)
                    
                } else {
                        let newPopup = PopupDialog(title: "Cannot update!", message: "Please check your internet connection or your information.", image: nil)
                        newPopup.addButton(DefaultButton(title: "Try again", action: nil))
                        self.present(newPopup, animated: true, completion: nil)
                }
                
                // release the view
                self.view.isUserInteractionEnabled = true
            })
        } else {
                print("error: no user!")
        }
    }
}
