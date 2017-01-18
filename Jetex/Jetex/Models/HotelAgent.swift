//
//  HotelAgent.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/17/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class HotelAgent: Mappable {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var imageUrl: String = ""
    dynamic var inProgress: Bool = false
    
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
        imageUrl <- map["image_url"]
        inProgress <- map["in_progress"]
    }
}
