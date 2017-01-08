//
//  FlightHistorySearch.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/6/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class FlightHistorySearch: Object, Mappable {
    dynamic var passengerInfo: PassengerInfo? = nil
    
    dynamic var departCity: String     = ""
    dynamic var arrivalCity: String    = ""
    dynamic var departDate: String     = ""
    dynamic var returnDate: String     = ""
    dynamic var adult: Int             = 1
    dynamic var children: Int          = 0
    dynamic var infant: Int            = 0
    dynamic var flightType: String     = ""
    dynamic var flightClass: String    = ""
    dynamic var departAirport: String  = ""
    dynamic var arrivalAirport: String = ""
    dynamic var departDateText: String = ""
    dynamic var returnDateText: String = ""
    dynamic var isRoundTrip : Bool     = false
    
    convenience init(info: PassengerInfo, searchAt searchTime: Date? = nil) {
        self.init()
        self.passengerInfo = info
        
        departCity = info.airportFrom!.name
        arrivalCity = info.airportTo!.name
        departDate = info.departDay!.toYYYYMMDDString()
        returnDate = info.isRoundTrip == true ? info.returnDay!.toYYYYMMDDString() : ""
        adult = info.passengers[0].value
        children = info.passengers[1].value
        infant = info.passengers[2].value
        flightType = info.isRoundTrip == true ? FlightType.RoundTrip.rawValue : FlightType.OneWay.rawValue
        flightClass = info.flightClass
        departAirport = info.airportFrom!.id
        arrivalAirport = info.airportTo!.id
        departDateText = info.departDay!.toFullMonthDay()
        returnDateText = info.isRoundTrip == true ? info.returnDay!.toFullMonthDay() : ""
        isRoundTrip = info.isRoundTrip
    }
    
    required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        departCity          <- map["departCity"]
        arrivalCity         <- map["arrivalCity"]
        departDate          <- map["departDate"]
        returnDate          <- map["returnDate"]
        adult               <- map["adult"]
        children            <- map["children"]
        infant              <- map["infant"]
        flightType          <- map["flightType"]
        flightClass         <- map["class"]
        departAirport       <- map["departAirport"]
        arrivalAirport      <- map["arrivalAirport"]
        departDateText      <- map["departDateText"]
        returnDateText      <- map["returnDateText"]
        isRoundTrip = (flightType == FlightType.RoundTrip.rawValue)
    }
    
    func requestInfoFromPassenger() -> PassengerInfo {
        if self.passengerInfo != nil {
            return self.passengerInfo!
        } else {
            self.passengerInfo = PassengerInfo()
            self.passengerInfo!.initialize()
            
            let realm = try! Realm()
            
            self.passengerInfo!.airportFrom = realm.object(ofType: Airport.self, forPrimaryKey: "\(departAirport)-\(departCity)")
            self.passengerInfo!.airportTo = realm.object(ofType: Airport.self, forPrimaryKey: "\(arrivalAirport)-\(arrivalCity)")
            
            self.passengerInfo!.departDay = departDate.toYYYYMMDD()
            self.passengerInfo!.isRoundTrip = isRoundTrip
            self.passengerInfo!.returnDay = isRoundTrip ? returnDate.toYYYYMMDD() : nil
            self.passengerInfo!.passengers[0].value = adult
            self.passengerInfo!.passengers[1].value = children
            self.passengerInfo!.passengers[2].value = infant
            self.passengerInfo!.flightClass = flightClass
            
            return self.passengerInfo!
        }
    }
}
