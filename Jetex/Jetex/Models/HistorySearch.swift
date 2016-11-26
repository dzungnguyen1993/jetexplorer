//
//  HistorySearch.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import Foundation

class HistorySearch : NSObject{
    var searchTime : Date!
    var searchType : HistorySearchType!
    
    var startDay: Date!
    var endDay : Date?
    
    init(type: HistorySearchType, startDay start: Date, endDay end: Date?, searchTime: Date? = nil) {
        self.searchType = type
        self.startDay = start
        self.endDay = end
        self.searchTime = (searchTime != nil ? searchTime! : Date())
    }
}

class FlightHistorySearch: HistorySearch {
    var from : City!
    var to : City!
    var isRoundTrip : Bool!
    var passengers: [Int]!
    
    init(from: City, to: City, isRoundTrip round: Bool, passengers: [Int], departAt startDay: Date, returnAt endDay: Date?, searchAt searchTime: Date? = nil) {
        super.init(type: .Flight, startDay: startDay, endDay: endDay, searchTime: searchTime)
        
        self.from = from
        self.to = to
        self.isRoundTrip = round
        self.passengers = passengers
    }
}

class HotelHistorySearch : HistorySearch {
    var hotelName: String!
    var passengers: [Int]!
    
    init(hotelName: String, passengers: [Int], checkInOn startDay: Date, checkOutOn endDay: Date?, searchAt searchTime: Date? = nil) {
        super.init(type: .Hotel, startDay: startDay, endDay: endDay, searchTime: searchTime)
        self.hotelName = hotelName
        self.passengers = passengers
    }
}

enum HistorySearchType {
    case Flight, Hotel
}


/*
 
 */
