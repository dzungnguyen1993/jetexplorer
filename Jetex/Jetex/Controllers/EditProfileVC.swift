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

class EditProfileVC: UITableViewController {
    
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var emailUpdateTextField: UIPaddingTextField!
    @IBOutlet weak var emailSubscriptionSwitch: UISwitch!
    
    let realm = try! Realm()
    var emailWarning, passwordWarning: WarningForInput!
    var currentUser: User!
    var needToResizeEmailTextField: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        needToResizeEmailTextField = false
        emailWarning = WarningForInput(setWarning: "Your email is not correct", for: emailUpdateTextField, withTitle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let currentUser = realm.objects(User.self).filter("isCurrentUser == true").first {
            self.currentUser = currentUser
            
            emailUpdateTextField.text = currentUser.email
            
            // show user name
            if let displayName = currentUser.displayName, displayName.characters.count > 0 {
                displayNameLabel.text = displayName
            } else if let firstName = currentUser.firstName, firstName.characters.count >= 0, let lastName = currentUser.lastName, lastName.characters.count >= 0, firstName.characters.count != lastName.characters.count {
                displayNameLabel.text = "\(firstName) \(lastName)"
            } else {
                displayNameLabel.text = currentUser.username
            }

            // TODO: Ask Duy API to get/set news letter
            emailSubscriptionSwitch.setOn(true, animated: true)
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
            emailUpdateTextField.becomeFirstResponder()
            break
        case 3:
            print("subscription")
            emailSubscriptionSwitch.setOn(!emailSubscriptionSwitch.isOn, animated: true)
            break
        case 4:
            print("sign out")
            let newPopup = PopupDialog(title: "Are you sure?", message: "You are about to log out...", image: UIImage(named: "loading.jpg"), buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
            
            newPopup.addButton(CancelButton(title: "No", action: nil))
            newPopup.addButton(DefaultButton(title: "Yes", action: {
                ProfileVC.isUserLogined = false
                _ = self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(newPopup, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if needToResizeEmailTextField == true && indexPath.section == 2 {
            return 76.0
        }
        return 44.0
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
        
        // show pop up
        let popup = PopupDialog(title: "Updating...", message: "Please wait", image: UIImage(named: "loading.jpg"), buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
        
        self.present(popup, animated: true, completion: nil)
        
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
                            ProfileVC.isUserLogined = true
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                        
                        return
                    }
                } else if let message = value.value(forKey: "message") as? String {
                    // hide pop up
                    print(message)
                    popup.dismiss({
                        let newPopup = PopupDialog(title: "Cannot Update", message: "Please check your internet connection or your information.", image: UIImage(named: "loading.jpg"))
                        newPopup.addButton(CancelButton(title: "Try again", action: {
                            self.emailUpdateTextField.text = self.currentUser.email
                            self.emailUpdateTextField.becomeFirstResponder()
                        }))
                        self.present(newPopup, animated: true, completion: nil)
                    })
                }
            } else {
                popup.dismiss({
                    let newPopup = PopupDialog(title: "Cannot Update", message: "Please check your internet connection or your information.", image: UIImage(named: "loading.jpg"))
                    newPopup.addButton(CancelButton(title: "Try again", action: {
                        self.emailUpdateTextField.text = self.currentUser.email
                        self.emailUpdateTextField.becomeFirstResponder()
                    }))
                    self.present(newPopup, animated: true, completion: nil)
                })
            }
        })
    }
    
    func textFieldResign() {
        emailUpdateTextField.resignFirstResponder()
    }

}
