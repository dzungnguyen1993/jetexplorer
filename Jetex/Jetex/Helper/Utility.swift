//
//  Utility.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/15/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import Darwin
import SystemConfiguration

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
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
    }
    
    class func distance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let p = 0.017453292519943295    // Math.PI / 180
        let a = 0.5 - cos((lat2 - lat1) * p)/2 +
            cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p))/2;
        
        return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
    }
}
