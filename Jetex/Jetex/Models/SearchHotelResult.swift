//
//  SearchHotelResult.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 12/23/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class SearchHotelResult: Mappable {
    var hotels = [Hotel]()
    var cheapestHotels = [Hotel]()
    var bestHotels = [Hotel]()
    var hotelPrices = [HotelPrice]()
    
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
    }
    
    func initSort() {
        sortCheapest(hotels: hotels)
        sortBest(hotels: hotels)
    }
    
    // sort cheapest
    func sortCheapest(hotels: [Hotel]) {
        self.cheapestHotels = hotels
        
        self.cheapestHotels.sort { (item1, item2) -> Bool in
            return true
        }
    }
    
    // sort fastest
    func sortBest(hotels: [Hotel]) {
        self.bestHotels = hotels
        
        self.bestHotels.sort { (item1, item2) -> Bool in
            return true
        }
    }
    
    func getPrice(ofHotel hotel: Hotel) -> AgentPrice? {
        for hotelPrice in self.hotelPrices {
            if hotelPrice.id == hotel.id {
                return hotelPrice.agentPrices.first
            }
        }
        
        return nil
    }
}
