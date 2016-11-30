//
//  Query.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/30/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Query: Mappable {
    dynamic var country: Int = 0
    dynamic var currency: String = ""
    dynamic var cabinClass: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    //
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
    func mapping(map: Map) {
        country <- map["Country"]
        currency <- map["Currency"]
        cabinClass <- map["CabinClass"]
    }
}
