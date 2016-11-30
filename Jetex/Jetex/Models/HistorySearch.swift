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
    dynamic var id : Int               = 0
    dynamic var createTime : Date      = Date()
    dynamic var createTimeText: String = ""
    dynamic var _dataType              = HistorySearchType.Flight.rawValue
    dynamic var isSynced : Bool        = false
    
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
        
        isSynced = false
        dataType = type
        createTime = Date()
        id = Int(createTime.timeIntervalSince1970)
        createTimeText = createTime.toFullMonthDayAndYear()
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        createTime      <- map["createTime"]
        createTimeText  <- map["createTimeText"]
        dataType        <- map["dataType"]
        
        id = Int(createTime.timeIntervalSince1970)
        isSynced = true
        
        if dataType == .Flight {
            flightHistory = FlightHistorySearch(map: map)
            
        } else {
            hotelHistory = HotelHistorySearch(map: map)
        }
    }
    
    func toJSON() -> [String : Any] {
        var json : [String: Any] = [:]
        json["dataType"] = _dataType
        json["createTime"] = createTime.toDateTimeUTCString()
        json["createTimeText"] = createTimeText
        
        if dataType == .Flight {
            let flightInfoDict = self.flightHistory!.toJSON()
            for (key, value) in flightInfoDict {
                json.updateValue(value, forKey: key)
            }
        } else if dataType == .Hotel {
            //let hotelDict = self.hotelHistory!.toJSON()
//            for (key, value) in hotelDict {
//                json.updateValue(value, forKey: key)
//            }
        }
        return json
    }
    
    // Build JSON from list
    static func historyListToJSON(historyList: Array<HistorySearch>!) -> [[String: Any]] {
        var JSONList: [[String: Any]] = []
        let realm = try! Realm()
        
        try! realm.write {
            for history in historyList {
                JSONList.append(history.toJSON())
            }
        }
        
        return JSONList
    }
}

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
    
    func requestInfoFromPassenger() -> PassengerInfo {
        if self.passengerInfo != nil {
            return self.passengerInfo!
        } else {
            self.passengerInfo = PassengerInfo()
            self.passengerInfo!.initialize()

            let realm = try! Realm()
            
            self.passengerInfo!.airportFrom = realm.object(ofType: Airport.self, forPrimaryKey: departAirport)
            self.passengerInfo!.airportTo = realm.object(ofType: Airport.self, forPrimaryKey: arrivalAirport)
            
//            self.passengerInfo!.airportFrom = Airport(JSON: ["Id" : departAirport, "CityId" : departCity])
////            self.passengerInfo!.airportFrom!.id = departAirport
//            
//            self.passengerInfo!.airportTo = Airport(JSON: ["Id" : arrivalAirport, "CityId" : arrivalCity])
////            self.passengerInfo!.airportTo!.id = arrivalAirport
//            
////            self.passengerInfo!.airportFrom!.cityId = departCity
////            self.passengerInfo!.airportTo!.cityId = arrivalCity
            self.passengerInfo!.departDay = departDate.toYYYYMMDD()
            self.passengerInfo!.isRoundTrip = isRoundTrip
            self.passengerInfo!.returnDay = isRoundTrip ? returnDate.toYYYYMMDD() : nil
            self.passengerInfo!.passengers[0].value = adult
            self.passengerInfo!.passengers[1].value = children
            self.passengerInfo!.passengers[2].value = infant
            
            return self.passengerInfo!
        }
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

