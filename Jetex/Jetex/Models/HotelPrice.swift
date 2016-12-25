//
//  HotelPrice.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 12/25/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class HotelPrice: Mappable {
    dynamic var id: Int = 0
    var agentPrices = [AgentPrice]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    //
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
    func mapping(map: Map) {
        id <- map["id"]
        agentPrices <- map["agent_prices"]
    }
}
