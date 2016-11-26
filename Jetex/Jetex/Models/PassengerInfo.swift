//
//  PassengerInfo.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/12/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class PassengerInfo {
    var airportFrom: Airport?
    var airportTo: Airport?
    var passengers: [Int] = [Int](repeating: 0, count: 5)
    var departDay, returnDay: Date?
    var isRoundTrip: Bool?
    
    init() {
        self.isRoundTrip = true
        self.departDay = Utility.initialCheckInDate
        self.returnDay = Utility.initialCheckOutDate
        self.passengers[0] = 1
    }
    
    func numberOfPassenger() -> Int {
        var c = 0
        for passenger in self.passengers {
            c = c + passenger
        }
        return c
    }
}
