//
//  FlightSearchVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/8/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

class FlightSearchVC: BaseViewController {
    
    @IBOutlet weak var viewFrom: PickInfoView!
    @IBOutlet weak var viewTo: PickInfoView!
    @IBOutlet weak var viewDepartDay: PickInfoView!
    @IBOutlet weak var viewReturnDay: PickInfoView!
    @IBOutlet weak var viewPassenger: UIView!
    @IBOutlet weak var lbNumberPassenger: UILabel!
    @IBOutlet weak var segmentFlightType: UISegmentedControl!
    
    var passengerInfo: PassengerInfo!
    let realm = try! Realm()
    
    @IBOutlet weak var imgPassenger: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passengerInfo = PassengerInfo()
        self.passengerInfo.initialize()

        self.addActionForViews()
        self.loadViewLocation()
        self.showNumberPassenger()
        self.loadViewDate()
        
        self.setImages()
        let attributes = [NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!]
        self.segmentFlightType.setTitleTextAttributes(attributes, for: .normal)
    }
    
    func loadViewLocation() {
        viewFrom.lbTitle.text = "From"
        
        if (passengerInfo.airportFrom != nil) {
            viewFrom.lbInfo.text = passengerInfo.airportFrom?.id
            viewFrom.lbSubInfo.text = passengerInfo.airportFrom?.name
        } else {
            viewFrom.lbInfo.text = "--"
            viewFrom.lbSubInfo.text = ""
        }
        
        viewTo.lbTitle.text = "To"
        
        if (passengerInfo.airportTo != nil) {
            viewTo.lbInfo.text = passengerInfo.airportTo?.id
            viewTo.lbSubInfo.text = passengerInfo.airportTo?.name
        } else {
            viewTo.lbInfo.text = "--"
            viewTo.lbSubInfo.text = ""
        }
        
        viewReturnDay.isHidden = !passengerInfo.isRoundTrip
    }
    
    func loadViewDate() {
        viewDepartDay.lbTitle.text = "Depart"
        
        viewReturnDay.lbTitle.text = "Return"
        
        showDateInfo()
    }
    
    func addActionForViews() {
        let tapViewFrom = UITapGestureRecognizer(target: self, action: #selector(pickLocationFrom(sender:)))
        viewFrom.addGestureRecognizer(tapViewFrom)
        
        let tapViewTo = UITapGestureRecognizer(target: self, action: #selector(pickLocationTo(sender:)))
        viewTo.addGestureRecognizer(tapViewTo)
        
        let tapViewDepart = UITapGestureRecognizer(target: self, action: #selector(pickDepartDay(sender:)))
        viewDepartDay.addGestureRecognizer(tapViewDepart)
        
        let tapViewReturn = UITapGestureRecognizer(target: self, action: #selector(pickReturnDay(sender:)))
        viewReturnDay.addGestureRecognizer(tapViewReturn)
        
        let tapViewPassenger = UITapGestureRecognizer(target: self, action: #selector(pickPassengers(sender:)))
        viewPassenger.addGestureRecognizer(tapViewPassenger)
    }

    // MARK: Switch round trip or one-way
    @IBAction func switchFlightType(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            viewReturnDay.isHidden = false
            try! realm.write {
               self.passengerInfo.isRoundTrip = true
            }
        } else {
            viewReturnDay.isHidden = true
            try! realm.write {
                self.passengerInfo.isRoundTrip = false
            }
        }
    }
    
    // MARK: Search
    @IBAction func clickSearch(_ sender: UIButton) {
        // check if info is valid
        if (passengerInfo.airportFrom == nil || passengerInfo.airportTo == nil) {
            showAlert(message: "You didn't choose the location.", andTitle: "Error")
            return
        }
        
        if (passengerInfo.airportFrom == passengerInfo.airportTo && passengerInfo.isRoundTrip == true) {
            showAlert(message: "You chose the same airport.", andTitle: "Error")
            return
        }
        
        if (passengerInfo.numberOfPassenger() == 0) {
            showAlert(message: "You didn't choose the number of passengers.", andTitle: "Error")
            return
        }
        
        gotoResultVC()
    }
    
    func gotoResultVC() {
        // save searching info into history
        saveSearchingInfoIntoHistory()
        
        let vc = FlightResultVC(nibName: "FlightResultVC", bundle: nil)
        vc.passengerInfo = self.passengerInfo
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func saveSearchingInfoIntoHistory() {
        let currentPassengerInfo = PassengerInfo(passengerInfo: self.passengerInfo)
        let flightInfo = FlightHistorySearch(info: currentPassengerInfo, searchAt: Date())
        let searchingHistory = HistorySearch(type: .Flight, flight: flightInfo, hotel: nil)
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(searchingHistory)
        }
        
        let historyList = Array(realm.objects(HistorySearch.self))
        
        if ProfileVC.isUserLogined {
            // user login, sync to server and save to current user
            let JSONlist = HistorySearch.historyListToJSON(historyList: historyList)
         
            NetworkManager.shared.syncHistoryToServer(historyData: JSONlist, completion: { (success, result) in
                if success {
                    // sync success.
                    let realm = try! Realm()
                    try! realm.write {
                        searchingHistory.isSynced = true
                    }
                } else {
                    // sync fail, saved it to nowhere in local.
                }
            })
        } else {
            // user is not loged in, save it o nowhere in local
            try! realm.write {
                realm.add(searchingHistory)
            }
        }
    }
}

extension FlightSearchVC: PickLocationDelegate {
    // MARK: Pick location
    func pickLocationFrom(sender: UITapGestureRecognizer) {
        pickLocation(isLocationFrom: true)
    }
    
    func pickLocationTo(sender: UITapGestureRecognizer) {
        let vc = LocationSearchVC(nibName: "LocationSearchVC", bundle: nil)
        vc.isLocationFrom = false
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pickLocation(isLocationFrom: Bool) {
        let vc = LocationSearchVC(nibName: "LocationSearchVC", bundle: nil)
        vc.isLocationFrom = isLocationFrom
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didPickLocation(airport: Airport, isLocationFrom: Bool) {
        if (isLocationFrom) {
            passengerInfo.airportFrom = airport
            loadViewLocation()
        } else {
            passengerInfo.airportTo = airport
            loadViewLocation()
        }
    }
}

extension FlightSearchVC: PickDateVCDelegate {
    // MARK: Pick date
    func pickDepartDay(sender: UITapGestureRecognizer) {
        gotoPickDateVC(indicatorPosition: .checkIn)
    }
    
    func pickReturnDay(sender: UITapGestureRecognizer) {
        gotoPickDateVC(indicatorPosition: .checkOut)
    }
    
    func gotoPickDateVC(indicatorPosition: IndicatorPosition) {
        let vc = PickDateVC(nibName: "PickDateVC", bundle: nil)
        vc.indicatorPosition = indicatorPosition
        vc.checkInDate = passengerInfo.departDay
        vc.checkOutDate = passengerInfo.returnDay
        vc.delegate = self
        
        if (passengerInfo.isRoundTrip == true) {
            vc.type = .roundtrip
        } else {
            vc.type = .oneway
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didFinishPickDate(checkInDate: Date?, checkOutDate: Date?) {
        passengerInfo.departDay = checkInDate
        passengerInfo.returnDay = checkOutDate
        
        showDateInfo()
    }
    
    func showDateInfo() {
        guard passengerInfo.departDay != nil else {return}
        viewDepartDay.lbInfo.text = passengerInfo.departDay?.toMonthDay()
        viewDepartDay.lbSubInfo.text = passengerInfo.departDay?.toWeekDay()
        
        guard passengerInfo.returnDay != nil else {return}
        viewReturnDay.lbInfo.text = passengerInfo.returnDay?.toMonthDay()
        viewReturnDay.lbSubInfo.text = passengerInfo.returnDay?.toWeekDay()
    }
}

extension FlightSearchVC: PickPassengerVCDelegate {
    // MARK: Pick passengers
    func pickPassengers(sender: UITapGestureRecognizer) {
        let vc = PickPassengerVC(nibName: "PickPassengerVC", bundle: nil)
        vc.passengers = passengerInfo.toArrayOfPassengers()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func donePickPassenger(passengers: [Int]) {
        passengerInfo.fromArrayOfPassengers(passengers: passengers)
        showNumberPassenger()
    }
    
    func showNumberPassenger() {
        var c = 0
        for number in passengerInfo.passengers {
            c += number.value
        }
        
        var suffix = " Person"
        if (c > 1) {
            suffix = " People"
        }
        
        self.lbNumberPassenger.text = String(c) + suffix
    }
}

// setup layout
extension FlightSearchVC {
    func setImages() {
        self.viewFrom.imgView.image = UIImage(fromHex: JetExFontHexCode.jetexPin.rawValue, withColor: UIColor(hex: 0x674290))
        self.viewTo.imgView.image = UIImage(fromHex: JetExFontHexCode.jetexPin.rawValue, withColor: UIColor(hex: 0x674290))
        self.viewDepartDay.imgView.image = UIImage(fromHex: JetExFontHexCode.jetexCheckin.rawValue, withColor: UIColor(hex: 0x674290))
        self.viewReturnDay.imgView.image = UIImage(fromHex: JetExFontHexCode.jetexCheckout.rawValue, withColor: UIColor(hex: 0x674290))
        self.imgPassenger.image = UIImage(fromHex: JetExFontHexCode.jetexPassengers.rawValue, withColor: UIColor(hex: 0x674290))
    }
}
