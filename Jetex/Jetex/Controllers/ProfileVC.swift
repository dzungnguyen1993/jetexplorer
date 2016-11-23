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
    func userAvatarPressed()
}

class ProfileVC: BaseViewController, LoginViewDelegate, UserInfoViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let appSettingText             = "App Settings"
    let currency                   = "Currency"
    let ratingAndFeedback          = "Rating & Feedback"
    
    // MARK: - Hard code for testing UI -> TODO: check it before release
    static var currentCurrencyType = "USD"
    static var isUserLogined       = false
    
    
    // MARK: - IBOutlet Variables
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewHeightLayoutConstraint: NSLayoutConstraint!
    
    var userInfoView: UserInfoView? = nil
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpMainView()
        refreshSettingTableView()
    }

    func setUpMainView(){
        if !ProfileVC.isUserLogined {
            // resize mainView
            mainViewHeightLayoutConstraint.constant = LoginView.itsRect.height
            self.mainView.layoutIfNeeded()
            
            // login view
            let loginView = LoginView(frame: LoginView.itsRect)
            loginView.delegate = self
            self.mainView.addSubview(loginView)
            
        } else {
            if userInfoView == nil {
                // resize mainView
                mainViewHeightLayoutConstraint.constant = UserInfoView.itsRect.height
                self.mainView.layoutIfNeeded()
            
                // profile info
                userInfoView = UserInfoView(frame: UserInfoView.itsRect)
                userInfoView!.delegate = self
                self.mainView.addSubview(userInfoView!)
            }
        }
    }
    
    // MARK:- Log In Delegate
    func signInWithFacebook() {
        let cellURL = "https://www.facebook.com"
        UIApplication.shared.open(URL(string: cellURL)!, options: [:], completionHandler: nil)
    }

    func signInWithGoogle() {
        let cellURL = "https://plus.google.com"
        UIApplication.shared.open(URL(string: cellURL)!, options: [:], completionHandler: nil)
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
    
    func userAvatarPressed() {
        let pickervc = UIImagePickerController()
        pickervc.allowsEditing = false
        pickervc.delegate = self
        pickervc.sourceType = .photoLibrary
        self.present(pickervc, animated: true) { 
            // done showing picker, what's next?
        }
    }
    
    // MARK: - Picture Picker Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // cancel
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // change the picture
            if userInfoView != nil {
                userInfoView!.userAvatar.image = image
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - App Setting Table View functions
    func setupTableView() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    
    func refreshSettingTableView(){
        settingTableView.reloadData()
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
            
            cell.detailTextLabel?.attributedText = NSAttributedString(string: ProfileVC.currentCurrencyType, attributes: [NSForegroundColorAttributeName : UIColor(hex: 0x515151), NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 15)!])
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
            // TODO: update the appId here
            let appId = 1159421121
            let reviewURL = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appId)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
            UIApplication.shared.open(URL(string: reviewURL)!, options: [:], completionHandler: nil)
            break
        default:
            break
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont(name: GothamFontName.Book.rawValue, size: 13)
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont(name: GothamFontName.Book.rawValue, size: 13)
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

