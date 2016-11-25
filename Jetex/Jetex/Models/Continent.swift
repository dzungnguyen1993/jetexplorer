//
//  Continent.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/24/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Continent: Object, Mappable {
    dynamic var id: String = ""
    dynamic var name: String = ""
    var countries = List<Country>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id <- map["Id"]
        name <- map["Name"]
        countries <- map["Countries"]
    }

}
