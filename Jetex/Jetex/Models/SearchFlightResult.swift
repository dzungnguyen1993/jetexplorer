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
    
    var carriers = [Carrier]()
    var places = [Place]()
    var segments = [Segment]()
    var legs = [Leg]()
    var itineraries = [Itinerary]()
    var agents = [Agent]()
    var currencies = [Currency]()
    
    var cheapestTrips = [Itinerary]()
    var fastestTrips = [Itinerary]()
    
    var filteredCheapTrip = [Itinerary]()
    var filteredFastTrip = [Itinerary]()
    var query: Query = Query()
    
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
        currencies <- map["Currencies"]
        query <- map["Query"]
    }
    
    func initSort() {
        sortCheapest(itineraries: itineraries)
        sortFastest(itineraries: itineraries)
    }
    
    // sort cheapest
    func sortCheapest(itineraries: [Itinerary]) {
        self.cheapestTrips = itineraries
        
        cheapestTrips.sort { (item1, item2) -> Bool in
            let pricingOption1 = item1.pricingOptions.first
            
            let pricingOption2 = item2.pricingOptions.first
            
            return pricingOption1!.price <= (pricingOption2!.price)
        }
    }
    
    // sort fastest
    func sortFastest(itineraries: [Itinerary]) {
        self.fastestTrips = itineraries
        
        fastestTrips.sort { (item1, item2) -> Bool in
            let leg1 = self.getLeg(withId: item1.outboundLegId)
            let duration1 = leg1?.duration
            
            let leg2 = self.getLeg(withId: item2.outboundLegId)
            let duration2 = leg2?.duration
            
            return duration1! <= duration2!
        }
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
    
    func getAgent(withId id: Int) -> Agent? {
        for agent in agents {
            if agent.id == id {
                return agent
            }
        }
        
        return nil
    }
    
    // MARK: Filtered
    func filterCheap() {
        
    }
    
    func filterFast() {
        
    }
    
    func applyFilter(filterObject: FilterObject) {
        var result = [Itinerary]()
        
        for item in self.itineraries {
            let leg = self.getLeg(withId: item.outboundLegId)
            
            var isValidStop = false
            
            let numberOfStop = leg?.stops.count
            
            // filter stops
            switch filterObject.stopType {
            case .none:
                isValidStop = numberOfStop == 0
                break
            case .one:
                isValidStop = numberOfStop! <= 1
                break
            default:
                isValidStop = true
            }
            
            
            // filter carriers
            var isValidCarrier = false
            
            let carrier = self.getCarrier(withId: (leg?.carriers.first)!)
            
            for index in filterObject.checkedCarriers {
                let checkCarrier = self.carriers[index]
                
                if carrier?.id == checkCarrier.id {
                    isValidCarrier = true
                    break
                }
            }
            
            
            // filter origin
            var isValidOrigin = false
            
            let origin = self.getStation(withId: (leg?.originStation)!)
            for airport in filterObject.checkedOrigin {
                if airport.id == origin?.code {
                    isValidOrigin = true
                    break
                }
            }
            
            // filter destination
            var isValidDestination = false
            
            let destination = self.getStation(withId: (leg?.destinationStation)!)
            for airport in filterObject.checkedDestination {
                if airport.id == destination?.code {
                    isValidDestination = true
                    break
                }
            }
            
            if isValidStop && isValidCarrier && isValidOrigin && isValidDestination{
                result.append(item)
            }
        }
        
        self.sortCheapest(itineraries: result)
        self.sortFastest(itineraries: result)
    }
}
