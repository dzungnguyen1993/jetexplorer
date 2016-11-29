//
//  FlightCellUtils.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class FlightCellUtils: NSObject {
    static let heightOfStopView = 30
    static let heightOfEachTransit = 125
    static let headerDetailsHeight = 44
    
    static func heightForDetailsOfFlightInfo(ofSearchResult searchResult: SearchFlightResult, forItinerary itinerary: Itinerary) -> Int {
        let legDepart = searchResult.getLeg(withId: itinerary.outboundLegId)
        let legReturn = searchResult.getLeg(withId: itinerary.inboundLegId)
        
        let heightDepart = heightForLeg(leg: legDepart)
        let heightReturn = heightForLeg(leg: legReturn)
        
        // heightDepart + space + heightReturn + space + heightOfButton
        return heightDepart + 8 + heightReturn + 16 + 44 + 32
    }
    
    static func heightForDetailsOfFlightInfo(legDepart: Leg?, legReturn: Leg?) -> Int {
        let heightDepart = heightForLeg(leg: legDepart)
        let heightReturn = heightForLeg(leg: legReturn)
        
        // heightDepart + space + heightReturn + space + heightOfButton
        return heightDepart + 8 + heightReturn + 16 + 44 + 32
    }
    
    static func heightForLeg(leg: Leg?) -> Int {
        guard leg != nil else { return 0 }
        return headerDetailsHeight + (leg!.stops.count + 1) * heightOfEachTransit + leg!.stops.count * heightOfStopView
    }
}
