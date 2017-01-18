//
//  RoomOffer.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/17/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class RoomOffer: Mappable {
    
    var policyDTO: [String: Any] = [:]
    var mealPlan : String           = ""
    var available: Int              = 0
    var rooms : [Room]              = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
    func mapping(map: Map) {
        mealPlan    <- map["meal_plan"]
        available   <- map["available"]
        rooms       <- map["room_offers"]
    }
    
    class Room: Mappable {
        
        var adults: Int     = 0
        var children: Int   = 0
        var type : String   = ""
        var typeId : String = ""
        
        /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
        required convenience init?(map: Map) {
            self.init()
        }
        
        /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
        func mapping(map: Map) {
            adults      <- map["adults"]
            children    <- map["children"]
            type        <- map["type"]
            typeId      <- map["typeId"]
        }
    }
    
}
