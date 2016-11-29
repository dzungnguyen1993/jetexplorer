//
//  SearchFlightResult.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/27/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class SearchFlightResult: Mappable {
    
    var carriers = [Carrier]()//List<Carrier>()
    var places = [Place]()
    var segments = [Segment]()
    var legs = [Leg]()
    var itineraries = [Itinerary]()
    var agents = [Agent]()
    
    var cheapestTrips = [Itinerary]()
    var fastestTrips = [Itinerary]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
    
    func mapping(map: Map) {
        carriers <- map["Carriers"]
        places <- map["Places"]
        segments <- map["Segments"]
        legs <- map["Legs"]
        itineraries <- map["Itineraries"]
        agents <- map["Agents"]
    }
    
    // sort cheapest
    func sortCheapest() {
        self.cheapestTrips = itineraries
    }
    
    // sort fastest
    func sortFastest() {
        self.fastestTrips = itineraries
    }
    
    // MARK: Query info
    func getLeg(withId id: String) -> Leg? {
        for leg in legs {
            if leg.id == id {
                return leg
            }
        }
        
        return nil
    }
    
    func getStation(withId id: Int) -> Place? {
        for place in places {
            if place.id == id {
                return place
            }
        }
        
        return nil
    }
    
    func getCarrier(withId id: Int) -> Carrier? {
        for carrier in carriers {
            if carrier.id == id {
                return carrier
            }
        }
        
        return nil
    }
    
    func getSegment(withId id: Int) -> Segment? {
        for segment in segments {
            if segment.id == id {
                return segment
            }
        }
        
        return nil
    }
}
