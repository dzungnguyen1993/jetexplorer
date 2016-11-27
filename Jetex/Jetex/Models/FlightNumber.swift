//
//  FlightNumber.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/28/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class FlightNumber: Mappable {
    dynamic var flightNumber: String = ""
    dynamic var carrierId: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
    func mapping(map: Map) {
        flightNumber <- map["FlightNumber"]
        carrierId <- map["CarrierId"]
    }

}
