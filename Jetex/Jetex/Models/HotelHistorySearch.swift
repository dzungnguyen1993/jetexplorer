//
//  HotelHistorySearch.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/6/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class HotelHistorySearch : Object, Mappable {
    dynamic var searchHotelInfo: SearchHotelInfo? = nil
    
    dynamic var hotelName: String      = ""
    dynamic var adult: Int             = 1
    dynamic var children: Int          = 0
    dynamic var infant: Int            = 0
    
    convenience init(hotelName: String, passengers: [Int], checkInOn startDay: Date, checkOutOn endDay: Date?, searchAt searchTime: Date? = nil) {
        self.init()
        self.hotelName  = hotelName
        self.adult      = passengers[0]
        self.children   = passengers[1]
        self.infant     = passengers[2]
    }
    
    convenience init(info: SearchHotelInfo, searchAt searchTime: Date? = nil) {
        self.init()
        self.searchHotelInfo = info
        
    }
    
    required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        
    }
    
    func requestInfoFromSearch() -> SearchHotelInfo {
        if self.searchHotelInfo != nil {
            return self.searchHotelInfo!
        } else {
            self.searchHotelInfo = SearchHotelInfo()
            self.searchHotelInfo!.initialize()
            
//            let realm = try! Realm()
//            
//            self.passengerInfo!.airportFrom = realm.object(ofType: Airport.self, forPrimaryKey: "\(departAirport)-\(departCity)")
//            self.passengerInfo!.airportTo = realm.object(ofType: Airport.self, forPrimaryKey: "\(arrivalAirport)-\(arrivalCity)")
//            
//            self.passengerInfo!.departDay = departDate.toYYYYMMDD()
//            self.passengerInfo!.isRoundTrip = isRoundTrip
//            self.passengerInfo!.returnDay = isRoundTrip ? returnDate.toYYYYMMDD() : nil
//            self.passengerInfo!.passengers[0].value = adult
//            self.passengerInfo!.passengers[1].value = children
//            self.passengerInfo!.passengers[2].value = infant
//            self.passengerInfo!.flightClass = flightClass
            
            return self.searchHotelInfo!
        }
    }
}

