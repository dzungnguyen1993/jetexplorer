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

class SearchHistoryVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var historyTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var signInViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInView: UIView!
    
    // MARK: - Data lists
    var allHistory: [HistorySearch]!
    var flightHistory: [HistorySearch]!
    var hotelHistory: [HistorySearch]!
    
    var unSyncHistoryList : Results<HistorySearch>!
    let realm = try! Realm()
    
    // MARK: - Filter
    enum HistorySearchingFilter {
        case All, Flights, Hotels
    }
    
    var filter: HistorySearchingFilter!
    
    // MARK: - override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set search all data as default
        filter = .All
        allHistory = []
        flightHistory = []
        hotelHistory = []
        
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
        
        // edit segment control font
        let attributes = [NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!]
        self.historyTypeSegmentControl.setTitleTextAttributes(attributes, for: .normal)
        
        // load data from local that is unsynced
        unSyncHistoryList = realm.objects(HistorySearch.self).filter("isSynced == false")
        
        // load all data
        allHistory = Array(realm.objects(HistorySearch.self))

        if ProfileVC.isUserLogined {
            // User is loged in
            signInViewHeightConstraint.constant = 0.0
            
            // check if there is any searchHistory in nowhere, then sync
            if unSyncHistoryList.count > 0 {
                let dict = HistorySearch.historyListToJSON(historyList: self.allHistory)
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
                            if self.allHistory.contains(search) {
                                continue
                            } else {
                                self.allHistory.append(search)
                            }
                        }
                        
                        self.allHistory = self.allHistory.sorted(by: { $0.id > $1.id })
                        self.processHistoryData()
                        self.resultTableView.reloadData()
                    }
                })
            }
            
        } else {
            // User is not loged in, ask them to login
            signInViewHeightConstraint.constant = 120.0
            //            // show the unsynced ones
            //            allHistory = Array(unSyncHistoryList)
        }
        
        // do a simple animation
        UIView.animate(withDuration: 0.25) {
            self.signInView.layoutIfNeeded()
            self.signInView.isHidden = ProfileVC.isUserLogined
            self.signInView.alpha = ProfileVC.isUserLogined ? 0.0 : 1.0
        }
        
        // reload table view
        self.allHistory = self.allHistory.sorted(by: { $0.id > $1.id })
        self.processHistoryData()
        self.resultTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Sign In if dont login yet.
    @IBAction func signInButtonPressed(_ sender: AnyObject) {
//        let vc = SignInVC(nibName: "SignInVC", bundle: nil)
//        _ = self.navigationController?.pushViewController(vc, animated: true)
        
        // go to profile vc
        _ = (self.tabBarController as? TabBarController)?.animateToTab(toIndex: 3)
    }
    
    // MARK: - Segment functions
    @IBAction func historyTypesSegmentValueChanged(_ sender: AnyObject) {
        switch historyTypeSegmentControl.selectedSegmentIndex {
        case 0:
            // all searches
            filter = .All
            break
        case 1:
            // flights
            filter = .Flights
            break
        case 2:
            // hotels
            filter = .Hotels
            break
        default:
            break
        }
        
        resultTableView.reloadData()
    }
    
    // MARK: - result table
    func processHistoryData() {
        self.flightHistory = []
        self.hotelHistory = []
        
        for search in self.allHistory {
            if search.dataType == .Flight {
                self.flightHistory.append(search)
            } else if search.dataType == .Hotel {
                self.hotelHistory.append(search)
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filter == .All {
            // all searches
            return allHistory.count
        }
        if filter == .Flights {
            // flights searches
            return flightHistory.count
        }
        if filter == .Hotels {
            // hotels searches
            return hotelHistory.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.resultTableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        
        if filter == .All {
            // all searches
            cell.fillData(data: allHistory[indexPath.row])
        }
        if filter == .Flights {
            // flights searches
            cell.fillData(data: flightHistory[indexPath.row])
        }
        if filter == .Hotels {
            // hotels searches
            cell.fillData(data: hotelHistory[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HistoryCell.CellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedCell: HistorySearch!
        
        if filter == .All {
            // all searches
            selectedCell = allHistory[indexPath.row]
        }
        else if filter == .Flights {
            // flights searches
            selectedCell = flightHistory[indexPath.row]
        }
        else if filter == .Hotels {
            // hotels searches
            selectedCell = hotelHistory[indexPath.row]
        }
        else {
            return
        }
        
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
                            
                            (vc as! FlightSearchVC).passengerInfo.flightClass = passengerInfo!.flightClass
                            (vc as! FlightSearchVC).updateCabinClassFromPassengerInfo()
                            (vc as! FlightSearchVC).loadViewLocation()
                            (vc as! FlightSearchVC).showNumberPassenger()
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
            var searchHotelInfo : SearchHotelInfo? = nil
            
            try! realm.write {
                searchHotelInfo = selectedCell.hotelHistory!.requestInfoFromSearch()
            }
            
            if !(searchHotelInfo != nil && searchHotelInfo!.city != nil && searchHotelInfo!.checkinDay != nil && searchHotelInfo!.checkoutDay != nil) {
                
                let popup = PopupDialog(title: "Your search is too old!", message: "", image: nil, buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
                let cancel = CancelButton(title: "Okay", dismissOnTap: true, action: nil)
                popup.addButton(cancel)
                let search = DefaultButton(title: "Make a new search", dismissOnTap: true, action: {
                    // go to searching vc
                    (self.tabBarController as? TabBarController)?.animateToTab(toIndex: 1, needResetToRootView: true, completion: nil)
                })
                
                popup.addButton(search)
                self.present(popup, animated: true, completion: nil)
                
                return
            }
            
            if searchHotelInfo?.checkinDay?.compare(Date().dateByAddingDays(days: -1)) == ComparisonResult.orderedAscending {
                // depart day is overdue. session expired.
                let popup = PopupDialog(title: "Your search is too old!", message: "", image: nil, buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
                let cancel = CancelButton(title: "Okay", dismissOnTap: true, action: nil)
                popup.addButton(cancel)
                let search = DefaultButton(title: "Update the dates", dismissOnTap: true, action: {
                    // go to searching vc
                    (self.tabBarController as? TabBarController)?.animateToTab(toIndex: 1, needResetToRootView: true, completion: { vc in
                        if vc is HotelSearchVC {
                            (vc as! HotelSearchVC).searchHotelInfo.city = searchHotelInfo!.city
                            (vc as! HotelSearchVC).searchHotelInfo.numberOfGuest = searchHotelInfo!.numberOfGuest
                            (vc as! HotelSearchVC).searchHotelInfo.numberOfRooms = searchHotelInfo!.numberOfRooms
                            (vc as! HotelSearchVC).refreshViewSinceNewSearchingInfo()
                        }
                    })
                })
                popup.addButton(search)
                self.present(popup, animated: true, completion: nil)
            } else {
                let vc = HotelResultVC(nibName: "HotelResultVC", bundle: nil)
                vc.searchInfo = searchHotelInfo!
                _ = self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
