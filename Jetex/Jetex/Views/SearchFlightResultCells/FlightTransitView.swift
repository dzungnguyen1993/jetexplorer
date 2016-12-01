//
//  FlightTransitView.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class FlightTransitView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lbCarrier: UILabel!
    @IBOutlet weak var lbCabinClass: UILabel!
    @IBOutlet weak var lbFlightNumber: UILabel!
    
    @IBOutlet weak var lbOriginAirport: UILabel!
    @IBOutlet weak var lbOriginCity: UILabel!
    @IBOutlet weak var lbDepart: UILabel!
    @IBOutlet weak var lbArrive: UILabel!
    @IBOutlet weak var lbDestinationAirport: UILabel!
    @IBOutlet weak var lbDestinationCity: UILabel!
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        Bundle.main.loadNibNamed("FlightTransitView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("FlightTransitView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
    }
    
    func showDetails(ofSearchResult searchResult: SearchFlightResult, forSegment segment: Segment) {
        // set carrier
        let carrier = searchResult.getCarrier(withId: segment.operatingCarrier)
        lbCarrier.text = carrier?.name
        lbFlightNumber.text = segment.flightNumber
        // TODO: set cabin class (maybe)
        lbCabinClass.text = "Economy"
        
        // set origin
        let origin = searchResult.getStation(withId: segment.originStation)
        lbOriginAirport.text = origin?.code
        lbOriginCity.text = origin?.name
        lbDepart.text = segment.departureDateTime.toDateTimeUTC().toShortTimeString()
        
        // set destination
        let destination = searchResult.getStation(withId: segment.destinationStation)
        lbDestinationAirport.text = destination?.code
        lbDestinationCity.text = destination?.name
        lbArrive.text = segment.arrivalDateTime.toDateTimeUTC().toShortTimeString()
    }
}
