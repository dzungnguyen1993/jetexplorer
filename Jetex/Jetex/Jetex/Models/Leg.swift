//
//  Leg.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/27/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Leg: Mappable {
    dynamic var id: String = ""
    var segmentIds = [Int]()
    dynamic var originStation: Int = 0
    dynamic var destinationStation: Int = 0
    dynamic var departure: String = ""
    dynamic var arrival: String = ""
    dynamic var duration: Int = 0
    dynamic var journeyMode: String = ""
    var stops = [Int]()
    var carriers = [Int]()
    var operatingCarriers = [Int]()
    dynamic var directionality: String = ""
    var flightNumbers = [FlightNumber]()
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    //
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
    func mapping(map: Map) {
        id <- map["Id"]
        segmentIds <- map["SegmentIds"]
        originStation <- map["OriginStation"]
        destinationStation <- map["DestinationStation"]
        departure <- map["Departure"]
        arrival <- map["Arrival"]
        duration <- map["Duration"]
        journeyMode <- map["JourneyMode"]
        stops <- map["Stops"]
        carriers <- map["Carriers"]
        operatingCarriers <- map["OperatingCarriers"]
        directionality <- map["Directionality"]
        flightNumbers <- map["FlightNumbers"]
    }
}
