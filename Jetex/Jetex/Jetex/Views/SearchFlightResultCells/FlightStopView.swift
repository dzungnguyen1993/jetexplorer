//
//  FlightStopView.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/18/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class FlightStopView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var lbTime: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        Bundle.main.loadNibNamed("FlightStopView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("FlightStopView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        
        viewTime.layer.borderColor = UIColor(hex: 0xE8615B).cgColor
        viewTime.layer.borderWidth = 1.0
    }
    
    func showDetails(ofSearchResult searchResult: SearchFlightResult, forSegmentBefore segmentBefore: Segment, andSegmentAfter segmentAfter: Segment, withStop stop: Place) {
        let dateArrive = segmentBefore.arrivalDateTime.toDateTimeUTC()
        let dateLeave = segmentAfter.departureDateTime.toDateTimeUTC()
        
        let diff = Calendar.current.dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: dateArrive, to: dateLeave)
        
        var strTime = ""
        
        let minute = diff.minute
        
        let hour = diff.hour
        
        if (minute! > 0) {
            strTime = (hour?.toString())! + "h" + (minute?.toString())! + "m"
        } else {
            strTime = (hour?.toString())! + "h"
        }
        
        lbTime.text = strTime + " stop in " + stop.name
    }
}
