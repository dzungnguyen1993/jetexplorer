//
//  Segment.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/27/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Segment: Mappable {
    dynamic var id: Int = 0
    dynamic var originStation: Int = 0
    dynamic var destinationStation: Int = 0
    dynamic var departureDateTime: String = ""
    dynamic var arrivalDateTime: String = ""
    dynamic var carrier: Int = 0
    dynamic var operatingCarrier: Int = 0
    dynamic var duration: Int = 0
    dynamic var flightNumber: String = ""
    dynamic var journeyMode: String = ""
    dynamic var directionality: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
    func mapping(map: Map) {
        id <- map["Id"]
        originStation <- map["OriginStation"]
        destinationStation <- map["DestinationStation"]
        departureDateTime <- map["DepartureDateTime"]
        arrivalDateTime <- map["ArrivalDateTime"]
        carrier <- map["Carrier"]
        operatingCarrier <- map["OperatingCarrier"]
        duration <- map["Duration"]
        flightNumber <- map["FlightNumber"]
        journeyMode <- map["JourneyMode"]
        directionality <- map["Directionality"]
    }
    

}
