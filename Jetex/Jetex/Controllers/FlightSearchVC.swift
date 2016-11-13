//
//  FlightSearchVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/8/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class FlightSearchVC: BaseViewController {
    
    @IBOutlet weak var viewFrom: PickInfoView!
    @IBOutlet weak var viewTo: PickInfoView!
    @IBOutlet weak var viewDepartDay: PickInfoView!
    @IBOutlet weak var viewReturnDay: PickInfoView!
    @IBOutlet weak var viewPassenger: UIView!
    @IBOutlet weak var lbNumberPassenger: UILabel!
    
    var passengerInfo: PassengerInfo! = PassengerInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addActionForViews()
        self.loadViewLocation()
        self.showNumberPassenger()
        self.loadViewDate()
    }
    
    func loadViewLocation() {
        viewFrom.imgView.image = UIImage(named: "")
        viewFrom.lbTitle.text = "From"
        
        if (passengerInfo.cityFrom != nil) {
            viewFrom.lbInfo.text = passengerInfo.cityFrom?.countryID
            viewFrom.lbSubInfo.text = passengerInfo.cityFrom?.countryName
        } else {
            viewFrom.lbInfo.text = "--"
            viewFrom.lbSubInfo.text = ""
        }
        
        viewTo.imgView.image = UIImage(named: "")
        viewTo.lbTitle.text = "To"
        
        if (passengerInfo.cityTo != nil) {
            viewTo.lbInfo.text = passengerInfo.cityTo?.countryID
            viewTo.lbSubInfo.text = passengerInfo.cityTo?.countryName
        } else {
            viewTo.lbInfo.text = "--"
            viewTo.lbSubInfo.text = ""
        }
    }
    
    func loadViewDate() {
        viewDepartDay.imgView.image = UIImage(named: "")
        viewDepartDay.lbTitle.text = "Depart"
        if (passengerInfo.departDay != nil) {
            
        } else {
            viewDepartDay.lbInfo.text = ""
            viewDepartDay.lbSubInfo.text = ""
        }
        
        viewReturnDay.imgView.image = UIImage(named: "")
        viewReturnDay.lbTitle.text = "Return"
        if (passengerInfo.returnDay != nil) {
            
        } else {
            viewReturnDay.lbInfo.text = ""
            viewReturnDay.lbSubInfo.text = ""
        }
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
            passengerInfo.isRoundTrip = true
        } else {
            viewReturnDay.isHidden = true
            passengerInfo.isRoundTrip = false
        }
    }
    
    // MARK: Search
    @IBAction func clickSearch(_ sender: UIButton) {
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
    
    func didPickLocation(city: City, isLocationFrom: Bool) {
        if (isLocationFrom) {
            passengerInfo.cityFrom = city
            loadViewLocation()
        } else {
            passengerInfo.cityTo = city
            loadViewLocation()
        }
    }
}

extension FlightSearchVC {
    // MARK: Pick date
    func pickDepartDay(sender: UITapGestureRecognizer) {
        let vc = PickDateVC(nibName: "PickDateVC", bundle: nil)
        vc.pickDateType = .Depart
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pickReturnDay(sender: UITapGestureRecognizer) {
        let vc = PickDateVC(nibName: "PickDateVC", bundle: nil)
           vc.pickDateType = .Return
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FlightSearchVC: PickPassengerVCDelegate {
    // MARK: Pick passengers
    func pickPassengers(sender: UITapGestureRecognizer) {
        let vc = PickPassengerVC(nibName: "PickPassengerVC", bundle: nil)
        vc.passengers = passengerInfo.passengers
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func donePickPassenger(passengers: [Int]) {
        passengerInfo.passengers = passengers
        showNumberPassenger()
    }
    
    func showNumberPassenger() {
        var c = 0
        for number in passengerInfo.passengers {
            c += number
        }
        
        var suffix = " Person"
        if (c > 1) {
            suffix = " Persons"
        }
        self.lbNumberPassenger.text = String(c) + suffix
    }
}
