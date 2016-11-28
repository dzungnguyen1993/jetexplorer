//
//  HistorySearch.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class HistorySearch: Object, Mappable {
    
    dynamic var createTime : Date    = Date()
    dynamic var createTimeText: String = ""
    dynamic var _dataType      = HistorySearchType.Flight.rawValue
    
    dynamic var flightHistory: FlightHistorySearch?
    dynamic var hotelHistory:  HotelHistorySearch?
    
    
    var dataType : HistorySearchType {
        get {
            return HistorySearchType(rawValue: _dataType)!
        }
        set {
            _dataType = newValue.rawValue
        }
    }
    
    convenience init(type: HistorySearchType = .Flight, flight: FlightHistorySearch? = nil, hotel: HotelHistorySearch? = nil) {
        self.init()
        if type == .Flight {
            flightHistory = flight
            hotelHistory = nil
        } else if type == .Hotel {
            hotelHistory = hotel
            flightHistory = flight
        }
        
        dataType = type
        createTime = Date()
        createTimeText = createTime.toFullMonthDayAndYear()
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
//    override class func primaryKey() -> String? {
//        return "createTime"
//    }
    
    func mapping(map: Map) {
        createTime      <- map["createTime"]
        createTimeText  <- map["createTimeText"]
        dataType        <- map["dataType"]
        
        if dataType == .Flight {
            flightHistory = FlightHistorySearch(map: map)
        } else {
            hotelHistory = HotelHistorySearch(map: map)
        }
    }
}
/*
 {
    "dataType": "flight",
    "departCity": "Ho Chi Minh City",
    "arrivalCity": "Hanoi",
    "departDate": "2016-11-18",
    "returnDate": "2016-11-19",
    "adult": 1,
    "children": 0,
    "infant": 0,
    "flightType": "Round Trip",
    "class": "",
    "departAirport": "SGN",
    "arrivalAirport": "HAN",
    "createTime": "Fri Nov 18 2016 02:15:09 GMT-0500 (EST)",
    "createTimeText": "November 18, 2016",
    "departDateText": "November 18",
    "returnDateText": "November 19"
 }
 */

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
        
        departCity = info.airportFrom!.cityId
        arrivalCity = info.airportTo!.cityId
        departDate = info.departDay!.toYYYYMMDDString()
        returnDate = info.isRoundTrip == true ? info.returnDay!.toYYYYMMDDString() : ""
        adult = info.passengers[0].value
        children = info.passengers[1].value
        infant = info.passengers[2].value
        flightType = "" // where's flight type?
        flightClass = "" // where?
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
        flightClass         <- map["flightClass"]
        departAirport       <- map["departAirport"]
        arrivalAirport      <- map["arrivalAirport"]
        departDateText      <- map["departDateText"]
        returnDateText      <- map["returnDateText"]
        
    }
}

class HotelHistorySearch : Object {
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
    
    required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        
    }
    
}

enum HistorySearchType: String {
    case Flight = "flight"
    case Hotel = "hotel"
}

