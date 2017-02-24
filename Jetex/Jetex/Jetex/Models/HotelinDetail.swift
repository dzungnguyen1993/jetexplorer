//
//  HotelinDetail.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/17/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class HotelinDetail: Mappable {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var description: String = ""
    dynamic var address: String = ""
    dynamic var district: Int = 0
    dynamic var numberOfRoom: Int = 0
    dynamic var popularity: Int = 0
    dynamic var popularityDesc: String = ""
    dynamic var longitude: Float = 0.0
    dynamic var latitude: Float = 0.0
    dynamic var score: Int = 0
    
    dynamic var star: Int = 0
    var images: [String: [String: [Int]]] = [:]
    var amenities: [Int] = [Int]()
    
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
        description <- map["description"]
        address <- map["address"]
        district <- map["district"]
        numberOfRoom <- map["number_of_rooms"]
        popularity <- map["popularity"]
        popularityDesc <- map["popularity_desc"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        score <- map["score"]
        star <- map["star_rating"]
        images <- map["images"]
        amenities <- map["amenities"]
    }
    
    func getImageUrlsList(withHost: String = "") -> [String] {
        var result : [String] = []
        let host = (withHost == "" ? "" : ("https://" + withHost))
        
        for (folder, values) in images {
            var maxSpec = Int.min
            var maxFileName = ""
            for (fileName, spec) in values {
                if spec.first! > maxSpec {
                    maxSpec = spec.first!
                    maxFileName = fileName
                }
            }
            result.append(host + folder + maxFileName)
        }
        return result
    }
}
