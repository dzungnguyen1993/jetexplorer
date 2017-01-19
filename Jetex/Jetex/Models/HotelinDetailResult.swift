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
    var amenities: [Amenity] = []
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
        amenities <- map["amenities"]
        imageHostUrl <- map["image_host_url"]
    }
    
    func findAgentForProvidedPrice(agentId: Int) -> HotelAgent? {
        // find the first agent that has id is agentId
        return self.agents.filter({ (agent) -> Bool in
            return agent.id == agentId
        }).first
    }
    
    func findAmenityFromId(amenityId: Int) -> Amenity? {
        return self.amenities.filter({ (amenity) -> Bool in
            return amenity.id == amenityId
        }).first
    }
}
