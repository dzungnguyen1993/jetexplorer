//
//  Hotel.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 12/23/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Hotel: Mappable {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var address: String = ""
    dynamic var distance: Double = 0
    dynamic var star: Int = 0
    dynamic var popularity: Int = 0
    dynamic var popularityDesc: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    //
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
    func mapping(map: Map) {
        id <- map["hotel_id"]
        name <- map["name"]
        address <- map["address"]
        distance <- map["distance_from_search"]
        star <- map["star_rating"]
        popularity <- map["popularity"]
        popularityDesc <- map["popularity_desc"]
    }
}
