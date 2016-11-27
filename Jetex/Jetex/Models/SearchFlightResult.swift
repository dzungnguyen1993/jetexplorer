//
//  SearchFlightResult.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/27/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class SearchFlightResult: Mappable {
    
    var carriers = [Carrier]()//List<Carrier>()
    var places = [Place]()
    var segments = [Segment]()
    var legs = [Leg]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
    
    func mapping(map: Map) {
        carriers <- map["Carriers"]
        places <- map["Places"]
        segments <- map["Segments"]
        legs <- map["Legs"]
    }
}
