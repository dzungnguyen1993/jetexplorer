//
//  ProfileVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/11/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

protocol LoginViewDelegate: class {
    func signInWithFacebook()
    func signInWithGoogle()
    func signInWithEmail()
    func signUp()
}

class ProfileVC: BaseViewController, LoginViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let appSettingText = "App Settings"
    let currency = "Currency"
    let currentCurrencyType = "USD"
    let ratingAndFeedback = "Rating & Feedback"
    
    // MARK: - IBOutlet Variables
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewHeightLayoutConstraint: NSLayoutConstraint!
    
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setUpMainView()
    }

    func setUpMainView(){
        if false {
            // resize mainView
            mainViewHeightLayoutConstraint.constant = LoginView.itsRect.height
            
            UIView.animate(withDuration: 0.01, animations: {
                self.mainView.layoutIfNeeded()
                }, completion: { (complete) in
                    if complete {
                        // login view
                        let loginView = LoginView(frame: LoginView.itsRect)
                        loginView.delegate = self
                        self.mainView.addSubview(loginView)
                    }
            })
        } else {
            // resize mainView
            mainViewHeightLayoutConstraint.constant = UserInfoView.itsRect.height
            
            UIView.animate(withDuration: 0.01, animations: {
                self.mainView.layoutIfNeeded()
                }, completion: { (complete) in
                    if complete {
                        // profile info
                        let userInfoView = UserInfoView(frame: UserInfoView.itsRect)
                        self.mainView.addSubview(userInfoView)
                    }
            })
        }
    }
    
    // MARK:- Log In Delegate
    func signInWithFacebook() {
    
    }

    func signInWithGoogle() {
    
    }
    
    func signInWithEmail() {
    
    }

    func signUp() {
        
    }
    
    // MARK: - App Setting Table View functions
    func setupTableView() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(60)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return appSettingText
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.accessoryType = .none
        switch indexPath.row {
        case 0:
            cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.text = currency
            cell.detailTextLabel?.text = currentCurrencyType
            break
        case 1:
            cell.textLabel?.text = ratingAndFeedback
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print(currency)
            break
        case 1:
            print(ratingAndFeedback)
            break
        default:
            break
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

