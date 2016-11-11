//
//  ProfileVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/11/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class ProfileVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appSettingText = "App Settings"
    let currency = "Currency"
    let currentCurrencyType = "USD"
    let ratingAndFeedback = "Rating & Feedback"
    
    // MARK: - IBOutlet Variables
    @IBOutlet weak var settingTableView: UITableView!
    
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    
    // MARK:- Sign In
    @IBAction func signInWithFacebook(_ sender: AnyObject) {
    
    }

    @IBAction func signInWithGoogle(_ sender: AnyObject) {
    
    }
    
    @IBAction func signInWithEmail(_ sender: AnyObject) {
    
    }
    
    // MARK: - Sign Up
    @IBAction func signUp(_ sender: AnyObject) {
        
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

