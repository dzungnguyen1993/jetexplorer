//
//  SearchHistoryVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import PopupDialog

class FlightSearchHistoryVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var signInViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInView: UIView!
    
    // MARK: - Data lists
    var historyList: Array<HistorySearch>!
    var unSyncHistoryList : Results<HistorySearch>!
    let realm = try! Realm()
    
    // MARK: - override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell prototype
        self.resultTableView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if (!Utility.isConnectedToNetwork()) {
            // no network
            let vc = NetworkErrorVC(nibName: "NetworkErrorVC", bundle: nil)
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
            return
        }
        
        // load data from local that is unsynced
        unSyncHistoryList = realm.objects(HistorySearch.self).filter("isSynced == false")
        
        // load all data
        historyList = Array(realm.objects(HistorySearch.self))
        
        if ProfileVC.isUserLogined {
            // User is loged in
            signInViewHeightConstraint.constant = 0.0
            
            // check if there is any searchHistory in nowhere, then sync
            if unSyncHistoryList.count > 0 {
                let dict = HistorySearch.historyListToJSON(historyList: self.historyList)
                NetworkManager.shared.syncHistoryToServer(historyData: dict, atView: self, showPopup: true, completion: { (success, searchesHistory) in
                    if success {
                        // delete all local history
                        let realm = try! Realm()
                        try! realm.write {
                            for unsyncedSearch in self.unSyncHistoryList {
                                unsyncedSearch.isSynced = true
                            }
                        }
                        
                        // reload data
                        for search in searchesHistory! {
                            if self.historyList.contains(search) {
                                continue
                            } else {
                                self.historyList.append(search)
                            }
                        }
                        self.resultTableView.reloadData()
                    }
                })
            }
            
        } else {
            // User is not loged in, ask them to login
            signInViewHeightConstraint.constant = 120.0
//            // show the unsynced ones
//            historyList = Array(unSyncHistoryList)
        }
        
        // do a simple animation
        UIView.animate(withDuration: 0.25) {
            self.signInView.layoutIfNeeded()
            self.signInView.isHidden = ProfileVC.isUserLogined
            self.signInView.alpha = ProfileVC.isUserLogined ? 0.0 : 1.0
        }
        
        // reload table view
        self.historyList = self.historyList.sorted(by: { $0.id > $1.id })
        self.resultTableView.reloadData()
    }
    
    // MARK: - Sign In if dont login yet.
    @IBAction func signInButtonPressed(_ sender: AnyObject) {
//        let vc = SignInVC(nibName: "SignInVC", bundle: nil)
//        _ = self.navigationController?.pushViewController(vc, animated: true)
        
        // go to profile vc
        _ = (self.tabBarController as? TabBarController)?.animateToTab(toIndex: 2)
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
            var passengerInfo : PassengerInfo? = nil
            
            try! realm.write {
                passengerInfo = selectedCell.flightHistory!.requestInfoFromPassenger()
            }
            
            if passengerInfo?.departDay?.compare(Date().dateByAddingDays(days: -1)) == ComparisonResult.orderedAscending {
                // depart day is overdue. session expired.
                let popup = PopupDialog(title: "Your search is too old!", message: "", image: nil, buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
                let cancel = CancelButton(title: "Okay", dismissOnTap: true, action: nil)
                popup.addButton(cancel)
                let search = DefaultButton(title: "Update the dates", dismissOnTap: true, action: {
                    // go to searching vc
                    (self.tabBarController as? TabBarController)?.animateToTab(toIndex: 0, needResetToRootView: true, completion: { vc in
                        if vc is FlightSearchVC {
                            (vc as! FlightSearchVC).passengerInfo.airportFrom = passengerInfo?.airportFrom
                            (vc as! FlightSearchVC).passengerInfo.airportTo = passengerInfo?.airportTo
                            (vc as! FlightSearchVC).passengerInfo.isRoundTrip = (passengerInfo?.isRoundTrip)!
                            (vc as! FlightSearchVC).passengerInfo.passengers[0].value = (passengerInfo?.passengers[0].value)!
                            (vc as! FlightSearchVC).passengerInfo.passengers[1].value = (passengerInfo?.passengers[1].value)!
                            (vc as! FlightSearchVC).passengerInfo.passengers[2].value = (passengerInfo?.passengers[2].value)!
//                            (vc as! FlightSearchVC).passengerInfo.passengers[3].value = (passengerInfo?.passengers[3].value)!
//                            (vc as! FlightSearchVC).passengerInfo.passengers[4].value = (passengerInfo?.passengers[4].value)!
                            
                            (vc as! FlightSearchVC).loadViewLocation()
                        }
                    })
                })
                popup.addButton(search)
                self.present(popup, animated: true, completion: nil)
                
            } else {
                let vc = FlightResultVC(nibName: "FlightResultVC", bundle: nil)
                vc.passengerInfo = passengerInfo!
                _ = self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if selectedCell.dataType == .Hotel {
            
        }
    }
}
