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
    
    static func heightForDetailsOfFlightInfo(flightInfo: FlightInfo) -> Int {
        let heightDepart = heightForDepartOfFlight(flightInfo: flightInfo)
        let heightReturn = heightForReturnOfFlight(flightInfo: flightInfo)
        
        // heightDepart + space + heightReturn + space + heightOfButton
        return heightDepart + 8 + heightReturn + 16 + 44 + 16
    }
    
    static func heightForDepartOfFlight(flightInfo: FlightInfo) -> Int {
        return headerDetailsHeight + flightInfo.numberOfTransit * heightOfEachTransit + (flightInfo.numberOfTransit - 1 ) * heightOfStopView
    }
    
    static func heightForReturnOfFlight(flightInfo: FlightInfo) -> Int {
               return headerDetailsHeight + flightInfo.numberOfTransit * heightOfEachTransit + (flightInfo.numberOfTransit - 1 ) * heightOfStopView
    }
}
