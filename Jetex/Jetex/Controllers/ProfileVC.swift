//
//  ProfileVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/11/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import FacebookCore
import FacebookLogin
import FacebookShare
import GoogleSignIn

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

class ProfileVC: BaseViewController, LoginViewDelegate, UserInfoViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, GIDSignInDelegate, GIDSignInUIDelegate {
    
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
    
    var userInfoView: UserInfoView?  = nil
    var loginView: LoginView?        = nil
    var currentUser: User?           = nil
    var realm : Realm!
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        realm = try! Realm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpMainView()
        refreshSettingTableView()
    }

    func setUpMainView(){
        if !ProfileVC.isUserLogined {
            // remove
            self.userInfoView?.removeFromSuperview()
            
            // resize mainView
            mainViewHeightLayoutConstraint.constant = LoginView.itsRect.height
            self.mainView.layoutIfNeeded()
            
            // login view
            if loginView == nil {
                loginView = LoginView(frame: LoginView.itsRect)
                loginView!.delegate = self
            }
            self.mainView.addSubview(loginView!)
            
        } else {
            
            self.loginView?.removeFromSuperview()
            
            // resize mainView
            mainViewHeightLayoutConstraint.constant = UserInfoView.itsRect.height
            self.mainView.layoutIfNeeded()
            
            if userInfoView == nil {
                // profile info
                userInfoView = UserInfoView(frame: UserInfoView.itsRect)
                userInfoView!.delegate = self
            }
            self.mainView.addSubview(userInfoView!)
            
            // get current user
            currentUser = realm.objects(User.self).filter("isCurrentUser == true").first
            if currentUser == nil {
                // if current User is not exist, login again
                ProfileVC.isUserLogined = false
                setUpMainView()
                return
            }
            
            // show user name
            if let displayName = currentUser!.displayName, displayName.characters.count > 0 {
                userInfoView!.userName.text = displayName
            } else if let firstName = currentUser!.firstName, firstName.characters.count > 0, let lastName = currentUser!.lastName, lastName.characters.count > 0 {
                userInfoView!.userName.text = "\(firstName) \(lastName)"
            } else {
                userInfoView!.userName.text = currentUser!.username
            }
            
            // show user Avatar
            let avatarURL = "\(APIURL.JetExAPI.base)/\(currentUser!.profileURL)"
            Alamofire.request(avatarURL).responseData(completionHandler: { (response) in
                if let data = response.result.value {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.userInfoView!.userAvatar.image = UIImage(data: data)
                    })
                }
            })
            
            // update the currency
            ProfileVC.currentCurrencyType = currentUser!.currency
        }
    }
    
    // MARK:- Log In Delegate
    
    func signInUsingAccessToken (accessToken: String, atAPI apiLink: String) {
        // TODO: show loading adicator
        
        // TODO: request to server
        let requestURL = APIURL.JetExAPI.base + apiLink
        let token = ["token" : accessToken]
        
        Alamofire.request(requestURL, method: .post, parameters: token, encoding: JSONEncoding.default).responseJSON { response in
            if let value = response.result.value as? NSDictionary {
                if let id = value.value(forKey: "_id") as? String, id != "" {
                    if let user = User(JSON: value as! [String: Any]) {
                        print(user)
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
                        
                        // back to previous screen
                        ProfileVC.isUserLogined = true
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                } else if let message = value.value(forKey: "message") as? String {
                    // TODO: Show notification here
                    print(message)
                }
            } else {
                print("Wrong info!")
                return
            }
        }
    }
    
    func signInWithFacebook() {
        
        let loginManager = LoginManager()
        // check if user alreay loged in
        if let accessToken = AccessToken.current {
            signInUsingAccessToken(accessToken: accessToken.authenticationToken, atAPI: APIURL.JetExAPI.signInWithFacebook)
            return
        }
        
        // if not, login
        loginManager.logIn([ReadPermission.publicProfile], viewController: self, completion:
            { loginResult in
                switch loginResult {
                case .failed(let error):
                    print(error)
                    break
                case .cancelled:
                    print("User cancelled login.")
                    break
                case .success(_, _, let accessToken):
                    print("Logged in! accessToken: \(accessToken)")
                    self.signInUsingAccessToken(accessToken: accessToken.authenticationToken, atAPI: APIURL.JetExAPI.signInWithFacebook)
                    break
                }
        })
    }

    func signInWithGoogle() {
        if let googleSignIn = GIDSignIn.sharedInstance() {
            googleSignIn.uiDelegate = self
            googleSignIn.scopes = ["https://www.googleapis.com/auth/plus.login"]
            googleSignIn.delegate = self
            googleSignIn.signIn()
        }
    }
    
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
            self.signInUsingAccessToken(accessToken: idToken!, atAPI: APIURL.JetExAPI.signInWithGoogle)
        } else {
            print("\(error.localizedDescription)")
        }
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
            // change the picture in UI
            if userInfoView != nil {
                userInfoView!.userAvatar.image = image
            }
            
            // update to server
            
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
            UIApplication.shared.open(URL(string: APIURL.JetExAPI.review)!, options: [:], completionHandler: nil)
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
}

