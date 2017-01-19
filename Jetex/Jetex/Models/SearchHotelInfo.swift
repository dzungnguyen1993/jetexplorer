//
//  SearchHotelInfo.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 12/16/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class SearchHotelInfo: Object, Mappable  {
    dynamic var city: City?
    dynamic var checkinDay: Date?
    dynamic var checkoutDay: Date?
    dynamic var numberOfGuest: Int = 1
    dynamic var numberOfRooms: Int = 1
    
    func initialize() {
        self.checkinDay = Utility.initialCheckInDate
        self.checkoutDay = Utility.initialCheckOutDate
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init (searchHotelInfo: SearchHotelInfo) {
        self.init()
        self.city = searchHotelInfo.city
        self.checkinDay = searchHotelInfo.checkinDay
        self.checkoutDay = searchHotelInfo.checkoutDay
        self.numberOfRooms = searchHotelInfo.numberOfRooms
        self.numberOfGuest = searchHotelInfo.numberOfGuest
    }
    
    func mapping(map: Map) {
    }

}
