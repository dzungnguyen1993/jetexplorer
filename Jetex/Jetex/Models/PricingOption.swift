//
//  PricingOption.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/28/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class PricingOption: Mappable {
    var agents = [Int]()
    dynamic var quoteAgeInMinutes: Int = 0
    dynamic var price: Double = 0.0
    dynamic var deeplinkUrl: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    //
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
    func mapping(map: Map) {
        agents <- map["Agents"]
        quoteAgeInMinutes <- map["QuoteAgeInMinutes"]
        price <- map["Price"]
        deeplinkUrl <- map["DeeplinkUrl"]
    }

}
