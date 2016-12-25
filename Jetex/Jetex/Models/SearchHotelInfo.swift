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
    dynamic var numberOfGuest: Int = 4
    dynamic var numberOfRooms: Int = 2
    
    func initialize() {
        self.checkinDay = Utility.initialCheckInDate
        self.checkoutDay = Utility.initialCheckOutDate
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init (searchHotelInfo: SearchHotelInfo) {
        self.init()
    }
    
    func mapping(map: Map) {
    }

}
