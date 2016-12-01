//
//  PassengerInfo.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/12/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

enum PassengerType: Int {
    case adult     = 0
    case children  = 1
//    case senior    = 2
    case infant    = 2
//    case lapInfant = 4
}

class PassengerInfo: Object, Mappable {
    dynamic var airportFrom: Airport?
    dynamic var airportTo: Airport?
    dynamic var departDay: Date?
    dynamic var returnDay: Date?
    dynamic var isRoundTrip: Bool = true
    let passengers = List<IntObject>()
    
    func initialize() {
        self.isRoundTrip = true
        self.departDay = Utility.initialCheckInDate
        self.returnDay = Utility.initialCheckOutDate
        
        let adult     = IntObject(); adult.value     = 1; self.passengers.append(adult)
        let children  = IntObject(); children.value  = 0; self.passengers.append(children)
//        let senior    = IntObject(); senior.value    = 0; self.passengers.append(senior)
        let infant    = IntObject(); infant.value    = 0; self.passengers.append(infant)
//        let lapInfant = IntObject(); lapInfant.value = 0; self.passengers.append(lapInfant)
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init (passengerInfo: PassengerInfo) {
        self.init()
        
        self.airportFrom = passengerInfo.airportFrom
        self.airportTo = passengerInfo.airportTo
        self.isRoundTrip = passengerInfo.isRoundTrip
        self.departDay = passengerInfo.departDay
        self.returnDay = passengerInfo.returnDay
        
        for passenger in passengerInfo.passengers {
            let obj = IntObject()
            obj.value = passenger.value
            self.passengers.append(obj)
        }
        
    }
    
    func mapping(map: Map) {
    }
    
    func numberOfPassenger() -> Int {
        var c = 0
        for passenger in self.passengers {
            c = c + passenger.value
        }
        return c
    }
    
    func toArrayOfPassengers() -> [Int] {
        var c = [Int]()
        for passenger in self.passengers {
            c.append(passenger.value)
        }
        return c
    }
    
    func fromArrayOfPassengers(passengers: [Int]) {
        self.passengers.removeAll()
        
        for value in passengers {
            let passenger = IntObject(); passenger.value = value; self.passengers.append(passenger)
        }
    }
}

public class IntObject: Object {
    dynamic var value : Int = 0
}
