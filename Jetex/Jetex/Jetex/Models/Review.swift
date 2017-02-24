//
//  Review.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/17/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Reviews: Mappable {
    var count: Int = 0
    var summary: String = ""
    var guestTypes: [ReviewBasedGuestType] = []
    var categories: [ReviewBasedCategory] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
    func mapping(map: Map) {
        count <- (map["count"], StringToIntTransform())
        summary <- map["summary"]
        guestTypes <- map["guest_types"]
        categories <- map["categories"]
    }
}

class ReviewBasedGuestType: Mappable {
    var id: String = ""
    var percentage : Int = 0
    var score: Int = 0
    var value: String = ""
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //
    //    override class func primaryKey() -> String? {
    //        return "id"
    //    }
    
    func mapping(map: Map) {
        id <- map["id"]
        percentage <- (map["perc"], StringToIntTransform())
        score <- (map["score"], StringToIntTransform())
        value <- map["value"]
    }
}

class ReviewBasedCategory: Mappable {
    var id: String = ""
    var name: String = ""
    var score: Int = 0
    var entries: [String] = []
    
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
        score <- (map["score"], StringToIntTransform())
        entries <- map["entries"]
    }
}


