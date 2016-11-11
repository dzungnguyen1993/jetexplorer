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
    
    var cityFrom: City? = nil
    var cityTo: City? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addActionForViews()
        self .loadViewLocation()
    }
    
    func loadViewLocation() {
        viewFrom.imgView.image = UIImage(named: "")
        viewFrom.lbTitle.text = "From"
        
        if (cityFrom != nil) {
            viewFrom.lbInfo.text = cityFrom?.countryID
            viewFrom.lbSubInfo.text = cityFrom?.countryName
        } else {
            viewFrom.lbInfo.text = "--"
            viewFrom.lbSubInfo.text = ""
        }
        
        viewTo.imgView.image = UIImage(named: "")
        viewTo.lbTitle.text = "To"
        
        if (cityTo != nil) {
            viewTo.lbInfo.text = cityTo?.countryID
            viewTo.lbSubInfo.text = cityTo?.countryName
        } else {
            viewTo.lbInfo.text = "--"
            viewTo.lbSubInfo.text = ""
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
        } else {
            viewReturnDay.isHidden = true
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
            cityFrom = city
            loadViewLocation()
        } else {
            cityTo = city
            loadViewLocation()
        }
    }
}

extension FlightSearchVC {
    // MARK: Pick date
    func pickDepartDay(sender: UITapGestureRecognizer) {
        print("ngu")
    }
    
    func pickReturnDay(sender: UITapGestureRecognizer) {
        print("ngu")
    }
}

extension FlightSearchVC {
    // MARK: Pick passengers
    func pickPassengers(sender: UITapGestureRecognizer) {
        print("ngu")
    }
}
