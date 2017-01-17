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
    var imageUrls: [String] = [String]()
    var images: [String: [String: [Int]]] = [:]
    var amenities: [Int] = [Int]()
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    
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
        imageUrls <- map["image_urls"]
        images <- map["images"]
        amenities <- map["amenities"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
    
    func getImageUrl() -> String {
        guard images.count > 0 else {
            return ""
        }
        let imageObj = images.first
        
        let key = (imageObj?.key)!
        let values = imageObj?.value
        
        let imageItem = values?.first
        let imageKey = (imageItem?.key)!
        
        let imageUrl = imageUrls.first
        guard imageUrls.count > 0 else {
            return ""
        }
        let indexOfBracket = imageUrl?.range(of: "{")
        let indexBeforeBracket = imageUrl?.index(before: (indexOfBracket?.upperBound)!)
        let host = (imageUrl?.substring(to: indexBeforeBracket!))!
        return "https://" + host + key + imageKey
    }
}
