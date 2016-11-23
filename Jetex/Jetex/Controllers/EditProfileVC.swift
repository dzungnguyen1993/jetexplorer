//
//  EditProfileVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/17/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class EditProfileVC: UITableViewController {
    
    @IBOutlet weak var emailUpdateTextField: UIPaddingTextField!
    @IBOutlet weak var emailSubscriptionSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            ProfileVC.isUserLogined = false
            _ = self.navigationController?.popViewController(animated: true)
            break
        default:
            break
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        textFieldResign()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldResign() {
        emailUpdateTextField.resignFirstResponder()
    }

}
