//
//  HotelinDetailResult.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/17/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class HotelinDetailResult: Mappable {
    var hotelPrices: [HotelPrice] = []
    var hotels: [HotelinDetail] = []
    var agents: [HotelAgent] = []
    var imageHostUrl : String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
    func mapping(map: Map) {
        hotels <- map["hotels"]
        hotelPrices <- map["hotels_prices"]
        agents <- map["agents"]
        imageHostUrl <- map["image_host_url"]
    }
}
