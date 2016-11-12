//
//  PassengerInfo.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/12/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class PassengerInfo {
    var cityFrom: City?
    var cityTo: City?
    var passengers: [Int] = [Int](repeating: 0, count: 5)
    var departDay, returnDay: NSDate?
    var isRoundTrip: Bool?
    
    init() {
        
    }
}
