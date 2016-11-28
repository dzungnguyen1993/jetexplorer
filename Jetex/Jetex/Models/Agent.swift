//
//  Agent.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/28/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Agent: Mappable {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var imageUrl: String = ""
    dynamic var type: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    //
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
    func mapping(map: Map) {
        id <- map["Id"]
        name <- map["Name"]
        imageUrl <- map["ImageUrl"]
        type <- map["Type"]
    }

}
