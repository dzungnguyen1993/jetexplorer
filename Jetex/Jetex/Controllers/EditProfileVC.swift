//
//  EditProfileVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/17/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class EditProfileVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        let view = UIView(frame:
//            CGRect(x: 0.0, y: -20.0, width: UIScreen.main.bounds.size.width, height: 20.0)
//        )
//        view.backgroundColor = UIColor.orange
//        
//        self.view.addSubview(view)
        super.viewWillAppear(animated)
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            break
        case 3:
            print("subscription")
            break
        case 4:
            print("sign out")
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
