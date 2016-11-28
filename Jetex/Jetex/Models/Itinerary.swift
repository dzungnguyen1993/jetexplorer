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
    
    func getSmallestPrice() -> Double {
        guard pricingOptions.count > 0 else {return 0}
        
        var min = pricingOptions[0].price
        
        for pricingOption in pricingOptions {
            if pricingOption.price < min {
                min = pricingOption.price
            }
        }
        return min
    }
}
