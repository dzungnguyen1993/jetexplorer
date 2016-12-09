//
//  EditProfileVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/17/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import PopupDialog

class EditProfileVC: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var saveNavButton: UIBarButtonItem!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var emailUpdateTextField: UIPaddingTextField!
    @IBOutlet weak var emailSubscriptionSwitch: UISwitch!
    
    let realm = try! Realm()
    var emailWarning, passwordWarning: WarningForInput!
    var currentUser: User!
    var needToResizeEmailTextField: Bool!
    var needToUpdateSubscribe = false
    var needToUpdateEmail = false
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        needToUpdateEmail = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailUpdateTextField.delegate = self
        needToResizeEmailTextField = false
        emailWarning = WarningForInput(setWarning: "Your email is not correct", for: emailUpdateTextField, withTitle: nil)
        saveNavButton.isEnabled = false
        
        if let currentUser = realm.objects(User.self).filter("isCurrentUser == true").first {
            self.currentUser = currentUser
            
            //  request to API here, check if user is subcribed
            let request = APIURL.JetExAPI.base + APIURL.JetExAPI.checkSubscribe
            let params = [
                "listCat": "newsletter",
                "email_address": currentUser.email
            ]
            
            // set unsubscribed as default
            emailSubscriptionSwitch.setOn(false, animated: true)
            Alamofire.request(request, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                print(response.result)
            })
            
            Alamofire.request(request, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: { response in
                if let value = response.result.value {
                    if value  == "subscribed" {
                        self.emailSubscriptionSwitch.setOn(true, animated: true)
                        return
                    }
                }
                // register
                let request = APIURL.JetExAPI.base + APIURL.JetExAPI.createSubscribe
                let params : [String : Any] = ["listCat": "newsletter",
                                               "email": [
                                                "email_address": currentUser.email,
                                                "status": "unsubscribed"
                    ]
                ]
                
                Alamofire.request(request, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response(completionHandler: { (response) in
                    if response.error != nil {
                        print(response.error!)
                    }
                })
                
            })
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUserInfoOnUI()
    }
    
    // update user info to UI
    func updateUserInfoOnUI() {
        if self.currentUser == nil {
            if let currentUser = realm.objects(User.self).filter("isCurrentUser == true").first {
                self.currentUser = currentUser
            } else {
                return
            }
        }
        
        emailUpdateTextField.text = currentUser.email
        
        // show user name
        if let displayName = currentUser.displayName, displayName.characters.count > 0 {
            displayNameLabel.text = displayName
        } else if let firstName = currentUser.firstName, firstName.characters.count >= 0, let lastName = currentUser.lastName, lastName.characters.count >= 0, firstName.characters.count != lastName.characters.count {
            displayNameLabel.text = "\(firstName) \(lastName)"
        } else {
            displayNameLabel.text = currentUser.username
        }

    }
    
    // refresh to get latest user information
    func refreshUserInformation() {
        
        // check
        if self.currentUser == nil {
            if let currentUser = realm.objects(User.self).filter("isCurrentUser == true").first {
                self.currentUser = currentUser
            } else {
                return
            }
        }
        
        // request to server
        let requestURL = APIURL.JetExAPI.base + APIURL.JetExAPI.getUserInfo
        Alamofire.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            if let value = response.result.value as? NSDictionary {
                if let id = value.value(forKey: "_id") as? String, id != "" {
                    if let user = User(JSON: value as! [String: Any]) {
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
                        
                        self.updateUserInfoOnUI()
                        return
                    }
                }
            }
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return CGFloat(40)
        }
        if section == 4 {
            return CGFloat(26)
        }
        return CGFloat(56)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 {
            return CGFloat(32)
        }
        return CGFloat(1)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont(name: GothamFontName.Book.rawValue, size: 13)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont(name: GothamFontName.Book.rawValue, size: 13)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textFieldResign()
        switch indexPath.section {
        case 0:
            let vc = ChangNameVC(nibName: "ChangNameVC", bundle: nil)
            _ = self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc = ChangePasswordVC(nibName: "ChangePasswordVC", bundle: nil)
            _ = self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            print("email")
//            emailUpdateTextField.becomeFirstResponder()
//            saveNavButton.isEnabled = true
//            needToUpdateEmail = true
            break
        case 3:
            print("subscription")
            emailSubscriptionSwitch.setOn(!emailSubscriptionSwitch.isOn, animated: true)
            saveNavButton.isEnabled = true
            needToUpdateSubscribe = true
            break
        case 4:
            print("sign out")
            let newPopup = PopupDialog(title: "Are you sure?", message: "You are about to log out...", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
            
            newPopup.addButton(CancelButton(title: "No", action: nil))
            newPopup.addButton(DefaultButton(title: "Yes", action: {
                let request = APIURL.JetExAPI.base + APIURL.JetExAPI.signOut
                Alamofire.request(request).responseString(completionHandler: { (response) in
                    if response.result.isSuccess {
                        ProfileVC.isUserLogined = false
                        _ = self.navigationController?.popViewController(animated: true)
                    } else {
                        
                    }
                })
            }))
            
            self.present(newPopup, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if needToResizeEmailTextField == true && indexPath.section == 2 {
            return 84.0
        }
        return 52.0
    }
    
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        textFieldResign()
        
        guard (emailUpdateTextField.text != nil && emailUpdateTextField.text!.contains("@")) else {
            print("email is not valid!")
            // resize the cell
            needToResizeEmailTextField = true
            self.tableView.reloadData()
            
            // show warning
            emailWarning.showWarning(animated: true, autoHide: true, after: 2, completion: {
                self.needToResizeEmailTextField = false
                self.tableView.reloadData()
            })
            return
        }
        
        saveNavButton.isEnabled = false
        
        // show pop up
        let popup = PopupDialog(title: "Updating...", message: "Please wait", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
        
        self.present(popup, animated: true, completion: nil)
        
        if needToUpdateSubscribe {
        // update Subscribe first
        let request = APIURL.JetExAPI.base + APIURL.JetExAPI.editSubscribe
        let params : [String : Any] = ["listCat": "newsletter",
                                       "email": [
                                        "email_address": self.emailUpdateTextField.text!,
                                        "status": self.emailSubscriptionSwitch.isOn ? "subscribed" : "unsubscribed"
            ]
        ]
        
        Alamofire.request(request, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseString { (response) in
            if let value = response.result.value {
                if value == "Not Found" {
                    
                    // register again
                    let request = APIURL.JetExAPI.base + APIURL.JetExAPI.createSubscribe
                    let params : [String : Any] = ["listCat": "newsletter",
                                                   "email": [
                                                    "email_address": self.emailUpdateTextField.text!,
                                                    "status": self.emailSubscriptionSwitch.isOn ? "subscribed" : "unsubscribed"
                        ]
                    ]
                    
                    Alamofire.request(request, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response(completionHandler: { (response) in
                        popup.dismiss({
                            self.needToUpdateSubscribe = false
                        })
                        if response.error != nil {
                            print(response.error!)
                        }
                    })
                } else {
                    popup.dismiss({
                        self.needToUpdateSubscribe = false
                    })
                }
            }
        }
        }
        
        if needToUpdateEmail {
        // update info to server
        let newInfo = ["email": self.emailUpdateTextField.text!]
        
        let requestURL = APIURL.JetExAPI.base + APIURL.JetExAPI.updateUserData
        Alamofire.request(requestURL, method: .post, parameters: newInfo, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if let value = response.result.value as? NSDictionary {
                if let id = value.value(forKey: "_id") as? String, id != "" {
                    if let user = User(JSON: value as! [String: Any]) {
                        print(user)
                        
                        let realm = try! Realm()
                        // save & update email
                        try! realm.write {
                            self.currentUser.email = self.emailUpdateTextField.text!
                        }
                        
                        popup.dismiss({
                            // back to previous screen
                            self.needToUpdateEmail = false
                            ProfileVC.isUserLogined = true
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                        
                        return
                    }
                } else if let message = value.value(forKey: "message") as? String {
                    // hide pop up
                    print(message)
                    popup.dismiss({
                        let newPopup = PopupDialog(title: "Cannot Update", message: message, image: nil)
                        newPopup.addButton(CancelButton(title: "Try again", action: {
                            self.emailUpdateTextField.text = self.currentUser.email
                            
                            self.saveNavButton.isEnabled = true
                        }))
                        self.present(newPopup, animated: true, completion: nil)
                    })
                }
            } else {
                popup.dismiss({
                    let newPopup = PopupDialog(title: "Cannot Update", message: "Please check your internet connection or your information.", image: nil)
                    newPopup.addButton(CancelButton(title: "Try again", action: {
                        self.emailUpdateTextField.text = self.currentUser.email
                        
                        self.saveNavButton.isEnabled = true
                    }))
                    self.present(newPopup, animated: true, completion: nil)
                })
            }
        })
        }
    }
    
    func textFieldResign() {
        emailUpdateTextField.resignFirstResponder()
    }
    
    @IBAction func emailSubscribeSwitchValueChanged(_ sender: Any) {
        saveNavButton.isEnabled = true
        needToUpdateSubscribe = true
    }
}
