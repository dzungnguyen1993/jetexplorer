//
//  SearchHistoryVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

class FlightSearchHistoryVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var signInViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInView: UIView!
    
    // MARK: - Data lists
    var historyList: Results<HistorySearch>!
    let realm = try! Realm()
    
    // MARK: - override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set search all data as default
        historyList = nil
        
        // register cell prototype
        self.resultTableView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if ProfileVC.isUserLogined {
            signInViewHeightConstraint.constant = 0.0
        } else {
            signInViewHeightConstraint.constant = 120.0
        }
        
        UIView.animate(withDuration: 0.25) {
            self.signInView.layoutIfNeeded()
            self.signInView.isHidden = ProfileVC.isUserLogined
        }
        
        // load data
        historyList = realm.objects(HistorySearch.self).sorted(byProperty: "createTime", ascending: true)
        self.resultTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Sign In if dont login yet.
    @IBAction func signInButtonPressed(_ sender: AnyObject) {
        let vc = SignInVC(nibName: "SignInVC", bundle: nil)
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - result table

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.resultTableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.fillData(data: historyList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HistoryCell.CellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: HistorySearch! = historyList[indexPath.row]
        
        // Configure the view for the selected state
        if selectedCell.dataType == .Flight {
            let vc = FlightResultVC(nibName: "FlightResultVC", bundle: nil)
            _ = self.navigationController?.pushViewController(vc, animated: true)
        } else if selectedCell.dataType == .Hotel {
            
        }
    }
}
