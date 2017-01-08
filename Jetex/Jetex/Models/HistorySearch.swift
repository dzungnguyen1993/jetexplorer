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
            flightHistory = nil
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
        
        createTime      <- (map["createTime"], FullDateTransform())
        createTimeText  <- map["createTimeText"]
        dataType        <- map["dataType"]
        
        id = Int(createTime.timeIntervalSince1970)
        isSynced = true
        
        if dataType == .Flight {
            flightHistory = FlightHistorySearch(map: map)
            
        } else { // Hotel
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
            let hotelDict = self.hotelHistory!.toJSON()
            for (key, value) in hotelDict {
                json.updateValue(value, forKey: key)
            }
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

enum HistorySearchType: String {
    case Flight = "flight"
    case Hotel = "hotel"
}

enum FlightType : String {
    case RoundTrip = "Round Trip"
    case OneWay = "One Way"
}

enum FlightClass : String {
    case Economy = "Economy"
    case Premium = "Premium Economy"
    case Business = "Business"
    case First = "First"
}

