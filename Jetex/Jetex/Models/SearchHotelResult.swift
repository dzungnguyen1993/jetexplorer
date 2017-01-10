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
    var amenities = [Amenity]()
    
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
        amenities <- map["amenities"]
    }
    
    func initSort() {
        sortCheapest(hotels: hotels)
        sortBest(hotels: hotels)
    }
    
    // sort cheapest
    func sortCheapest(hotels: [Hotel]) {
        self.cheapestHotels = hotels
        
        self.cheapestHotels.sort { (hotel1, hotel2) -> Bool in
            let agentPrice1 = self.getPrice(ofHotel: hotel1)
            
            let agentPrice2 = self.getPrice(ofHotel: hotel2)
            
            return agentPrice1!.priceTotal < agentPrice2!.priceTotal
        }
    }
    
    // sort fastest
    func sortBest(hotels: [Hotel]) {
        self.bestHotels = hotels
        
        self.bestHotels.sort { (hotel1, hotel2) -> Bool in
            return hotel1.popularity > hotel2.popularity
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
    
    func applyFilter(filterObject: FilterHotelObject) {
        var result = [Hotel]()
        
        for hotel in self.hotels {
            
            // filter price
            let price = (self.getPrice(ofHotel: hotel)?.priceTotal)!
            let isValidPrice = price >= Double(filterObject.minPrice) && price <= Double(filterObject.maxPrice)
            
            // filter star
            let isValidStar = hotel.star >= Int(filterObject.minStar) && hotel.star <= Int(filterObject.maxStar)
            
            // filter rating
            let score = Float(hotel.popularity) / 10
            let isValidRating = score >= filterObject.minRating && score <= filterObject.maxRating
            
            // filter amenity
            var isValidAmenity = true
            for amenityId in filterObject.selectedAmenities {
                if !self.amenities.contains(where: { (amenity) -> Bool in
                    return amenity.id == amenityId
                }) {
                    isValidAmenity = false
                    break
                }
            }
            
            if isValidPrice && isValidStar && isValidRating && isValidAmenity {
                result.append(hotel)
            }
        }
        
        self.sortCheapest(hotels: result)
        self.sortBest(hotels: result)
    }
}
