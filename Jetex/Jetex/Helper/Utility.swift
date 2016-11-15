//
//  Utility.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/15/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class Utility {
    static let initialCheckInDate: Date = {
        let date = Calendar.current.date(byAdding: Calendar.Component.day, value: 0, to: Date())!
        return Calendar.current.startOfDay(for: date)
    }()
    
    static let initialCheckOutDate: Date = {
        let date = Calendar.current.date(byAdding: Calendar.Component.day, value: 0, to: Date())!
        let startDate = Calendar.current.startOfDay(for: date)
        let d2 = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: startDate)!
        return Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: startDate)!
    }()
}
