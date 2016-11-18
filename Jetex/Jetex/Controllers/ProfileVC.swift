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

protocol UserInfoViewDelegate: class{
    func viewAndEditProfile()
}

class ProfileVC: BaseViewController, LoginViewDelegate, UserInfoViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpMainView()
    }

    func setUpMainView(){
        if true {
            // resize mainView
            mainViewHeightLayoutConstraint.constant = LoginView.itsRect.height
            self.mainView.layoutIfNeeded()
            
            // login view
            let loginView = LoginView(frame: LoginView.itsRect)
            loginView.delegate = self
            self.mainView.addSubview(loginView)
            
        } else {
            // resize mainView
            mainViewHeightLayoutConstraint.constant = UserInfoView.itsRect.height
            self.mainView.layoutIfNeeded()
            
            // profile info
            let userInfoView = UserInfoView(frame: UserInfoView.itsRect)
            userInfoView.delegate = self
            self.mainView.addSubview(userInfoView)
        }
    }
    
    // MARK:- Log In Delegate
    func signInWithFacebook() {
    
    }

    func signInWithGoogle() {
    
    }
    
    func signInWithEmail() {
        let vc = SignInVC(nibName: "SignInVC", bundle: nil)
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }

    func signUp() {
        let vc = SignUpVC(nibName: "SignUpVC", bundle: nil)
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - User Info Delegate
    func viewAndEditProfile() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "editProfileVC") as! EditProfileVC
        
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
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
            cell.accessoryType = .disclosureIndicator
            
            cell.textLabel?.attributedText = NSAttributedString(string: currency, attributes: [NSForegroundColorAttributeName : UIColor(hex: 0x515151), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 15)!])
            
            cell.detailTextLabel?.attributedText = NSAttributedString(string: currentCurrencyType, attributes: [NSForegroundColorAttributeName : UIColor(hex: 0x515151), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 15)!])
            break
        case 1:
            cell.textLabel?.attributedText = NSAttributedString(string: ratingAndFeedback, attributes: [NSForegroundColorAttributeName : UIColor(hex: 0x515151), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 15)!])
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = SelectCurrencyVC(nibName: "SelectCurrencyVC", bundle: nil)
            _ = self.navigationController?.pushViewController(vc, animated: true)
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

