//
//  Itinerary.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/28/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Itinerary: Mappable {
    
    dynamic var outboundLegId: String = ""
    dynamic var inboundLegId: String = ""
    var pricingOptions = [PricingOption]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    //
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
    func mapping(map: Map) {
        outboundLegId <- map["OutboundLegId"]
        inboundLegId <- map["InboundLegId"]
        pricingOptions <- map["PricingOptions"]
    }
}
