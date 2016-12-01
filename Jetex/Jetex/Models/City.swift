//
//  City.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/10/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class City: Object, Mappable {
//    var cityName: String
//    var countryName: String
//    var countryID: String!
//    
//    init(cityName: String, countryName: String,  countryID: String! = nil){
//        self.name = cityName
//        self.countryName = countryName
//        self.countryID = countryID
//    }
    
    /////
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var iataCode: String = ""
    dynamic var countryId: String = ""
    var airports = List<Airport>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id <- map["Id"]
        name <- map["Name"]
        airports <- map["Airport"]
        iataCode <- map["IataCode"]
        countryId <- map["CountryId"]
    }

}
