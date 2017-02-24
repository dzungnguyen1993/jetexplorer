//
//  FlightResultDetailsView.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/17/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class FlightResultDetailsView: UIView {

    @IBOutlet var contentView: UIView!
    let headerHeight = 44
    @IBOutlet weak var lbOrigin: UILabel!
    @IBOutlet weak var lbDestination: UILabel!
    @IBOutlet weak var lbDepart: UILabel!
 
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        Bundle.main.loadNibNamed("FlightResultDetailsView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("FlightResultDetailsView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
    }
    
    func addDetails(flightInfo: FlightInfo) {
        for i in 0..<flightInfo.numberOfTransit-1 {
            // add transit view
            let x = 0
            var y = FlightCellUtils.headerDetailsHeight + i*(FlightCellUtils.heightOfEachTransit + FlightCellUtils.heightOfStopView)
            let transitView = FlightTransitView(frame: CGRect(x: x, y: y , width: Int(self.frame.width), height: FlightCellUtils.heightOfEachTransit))
            
            self.addSubview(transitView)
            
            // add stop view
            y = y + FlightCellUtils.heightOfEachTransit
            let stopView = FlightStopView(frame: CGRect(x: x, y: y, width: Int(self.frame.width), height: FlightCellUtils.heightOfStopView))
            
            self.addSubview(stopView)
        }
        
        // add last transit view
        let x = 0
        let lastIdx = flightInfo.numberOfTransit - 1
        let y = headerHeight + lastIdx*(FlightCellUtils.heightOfEachTransit + FlightCellUtils.heightOfStopView)
        let transitView = FlightTransitView(frame: CGRect(x: x, y: y , width: Int(self.frame.width), height: FlightCellUtils.heightOfEachTransit))
        
        self.addSubview(transitView)
    }
    
    func addDetails(ofSearchResult searchResult: SearchFlightResult, forLeg leg: Leg) {
        // set header
        let origin = searchResult.getStation(withId: leg.originStation)
        let destination = searchResult.getStation(withId: leg.destinationStation)
        lbOrigin.text = origin?.code
        lbDestination.text = destination?.code
        lbDepart.text = leg.departure.toDateTimeUTC().toFullWeekMonthDayAndYear()

        var maxDurationSegment = 0
        for i in 0..<leg.segmentIds.count {
            let currentSegment = searchResult.getSegment(withId: leg.segmentIds[i])
            maxDurationSegment = max(maxDurationSegment, (currentSegment?.duration)!)
        }
        
        for i in 0..<leg.segmentIds.count {
            let currentSegment = searchResult.getSegment(withId: leg.segmentIds[i])
            
            // add transit view
            let x = 0
            var y = FlightCellUtils.headerDetailsHeight + i*(FlightCellUtils.heightOfEachTransit + FlightCellUtils.heightOfStopView)
            let transitView = FlightTransitView(frame: CGRect(x: x, y: y , width: Int(self.frame.width), height: FlightCellUtils.heightOfEachTransit))
            transitView.showDetails(ofSearchResult: searchResult, forSegment: currentSegment!)
            
            let ratio = CGFloat((currentSegment?.duration)!) / CGFloat(maxDurationSegment)
            transitView.constraintWidth.constant = max(ratio * (self.frame.size.width - 250), 5)
        
            self.addSubview(transitView)
            
            // add stop view
            // not add stop view at the last segment
            if (i == leg.segmentIds.count - 1) {
                continue
            }
            
            y = y + FlightCellUtils.heightOfEachTransit
            let stopView = FlightStopView(frame: CGRect(x: x, y: y, width: Int(self.frame.width), height: FlightCellUtils.heightOfStopView))
            
            let stop = searchResult.getStation(withId: leg.stops[i])
            let nextSegment = searchResult.getSegment(withId: leg.segmentIds[i+1])
            
            stopView.showDetails(ofSearchResult: searchResult, forSegmentBefore: currentSegment!, andSegmentAfter: nextSegment!, withStop: stop!)
            
            self.addSubview(stopView)
        }
    }
}
