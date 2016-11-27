//
//  Place.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/27/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Place: Mappable {
    dynamic var id: Int = 0
    dynamic var parentId: Int = 0
    dynamic var code: String = ""
    dynamic var type: String = ""
    dynamic var name: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
    
    func mapping(map: Map) {
        id <- map["Id"]
        parentId <- map["ParentId"]
        code <- map["Code"]
        type <- map["Type"]
        name <- map["Name"]
    }

}
