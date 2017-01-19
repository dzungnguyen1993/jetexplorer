//
//  Amenity.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 1/8/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Amenity: Mappable {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var key: String = ""
    dynamic var parentId: Int = -1
    
    required convenience init?(map: Map) {
        self.init()
    }
    //
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        key <- map["key"]
        
        if map.JSON.keys.contains("parent") {
            parentId <- map["parent"]
        }
    }
}
