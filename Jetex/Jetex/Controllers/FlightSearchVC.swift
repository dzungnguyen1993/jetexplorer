//
//  FlightSearchVC.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/8/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class FlightSearchVC: BaseViewController {
    
    
    @IBOutlet weak var viewFrom: UIView!
    @IBOutlet weak var viewTo: UIView!
    @IBOutlet weak var viewDepartDay: UIView!
    @IBOutlet weak var viewReturnDay: UIView!
    @IBOutlet weak var viewPassenger: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addActionForViews()
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
    
    // MARK: Pick location
    func pickLocationFrom(sender: UITapGestureRecognizer) {
        let vc = LocationSearchVC(nibName: "LocationSearchVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pickLocationTo(sender: UITapGestureRecognizer) {
        let vc = LocationSearchVC(nibName: "LocationSearchVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Pick date
    func pickDepartDay(sender: UITapGestureRecognizer) {
        print("ngu")
    }
    
    func pickReturnDay(sender: UITapGestureRecognizer) {
        print("ngu")
    }
    
    // MARK: Pick passengers
    func pickPassengers(sender: UITapGestureRecognizer) {
        print("ngu")
    }
    
    // MARK: Search
    @IBAction func clickSearch(_ sender: UIButton) {
    }
}
