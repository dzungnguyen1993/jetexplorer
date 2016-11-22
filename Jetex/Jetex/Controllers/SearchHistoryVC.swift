//
//  SearchHistoryVC.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class SearchHistoryVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var historyTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var signInViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInView: UIView!
    
    // MARK: - Data lists
    var allHistory: [HistorySearch]!
    var flightHistory: [FlightHistorySearch]!
    var hotelHistory: [HotelHistorySearch]!
    
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
        
        // init mock data
        initMockData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // edit segment control font
        let attributes = [NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!]
        self.historyTypeSegmentControl.setTitleTextAttributes(attributes, for: .normal)
        
        if ProfileVC.isUserLogined {
            signInViewHeightConstraint.constant = 0.0
        } else {
            signInViewHeightConstraint.constant = 120.0
        }
        
        UIView.animate(withDuration: 0.25) {
            self.signInView.layoutIfNeeded()
            self.signInView.isHidden = ProfileVC.isUserLogined
        }
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
    
    func initMockData() {
        
        // mock up flights
        flightHistory.append(FlightHistorySearch(from: City.init(cityName: "Ho Chi Minh", countryName: "Viet Name"), to: City.init(cityName: "Singapore", countryName: "Singapore"), isRoundTrip: true, passengers: [2, 0, 1, 0, 0], departAt: Date().addingTimeInterval(-10000), returnAt: Date()))
        
        flightHistory.append(FlightHistorySearch(from: City.init(cityName: "Ho Chi Minh", countryName: "Viet Name"), to: City.init(cityName: "Bangkok", countryName: "Thailand"), isRoundTrip: true, passengers: [1, 0, 1, 0, 0], departAt: Date().addingTimeInterval(-8000), returnAt: Date()))
        
        flightHistory.append(FlightHistorySearch(from: City.init(cityName: "Ho Chi Minh", countryName: "Viet Name"), to: City.init(cityName: "Sysney", countryName: "Australia"), isRoundTrip: true, passengers: [1, 1, 1, 0, 0], departAt: Date().addingTimeInterval(-6000), returnAt: Date()))
        
        flightHistory.append(FlightHistorySearch(from: City.init(cityName: "Ho Chi Minh", countryName: "Viet Name"), to: City.init(cityName: "Singapore", countryName: "Singapore"), isRoundTrip: true, passengers: [1, 0, 0, 0, 0], departAt: Date().addingTimeInterval(-4000), returnAt: Date()))
        
        flightHistory.append(FlightHistorySearch(from: City.init(cityName: "Ho Chi Minh", countryName: "Viet Name"), to: City.init(cityName: "Singapore", countryName: "Singapore"), isRoundTrip: true, passengers: [2, 0, 0, 0, 0], departAt: Date().addingTimeInterval(-2000), returnAt: Date()))
        
        // mock up hotels
        hotelHistory.append(HotelHistorySearch(hotelName: "The Imperial", passengers: [2,0], checkInOn: Date().addingTimeInterval(-40000), checkOutOn: Date()))
        
        hotelHistory.append(HotelHistorySearch(hotelName: "The Romeliess", passengers: [2,0], checkInOn: Date().addingTimeInterval(-20000), checkOutOn: Date()))
        
        hotelHistory.append(HotelHistorySearch(hotelName: "Intercontinetal", passengers: [2,0], checkInOn: Date().addingTimeInterval(-10000), checkOutOn: Date()))
        
        hotelHistory.append(HotelHistorySearch(hotelName: "Diamond", passengers: [1,0], checkInOn: Date().addingTimeInterval(-2000), checkOutOn: Date()))
        
        // sum up to all
        for flight in flightHistory {
            allHistory.append(flight as HistorySearch)
        }
        for hotel in hotelHistory {
            allHistory.append(hotel as HistorySearch)
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
        if selectedCell.searchType == .Flight {
            let vc = FlightResultVC(nibName: "FlightResultVC", bundle: nil)
            _ = self.navigationController?.pushViewController(vc, animated: true)
        } else if selectedCell.searchType == .Hotel {
            
        }
    }
}
