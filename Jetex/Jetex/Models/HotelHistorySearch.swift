//
//  HotelHistorySearch.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/6/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class HotelHistorySearch : Object, Mappable {
    dynamic var searchHotelInfo: SearchHotelInfo?  = nil
    
    dynamic var cityId : String                    = ""
    dynamic var hotelName: String                  = "" // or City
    dynamic var numberOfRooms: Int                 = 1
    dynamic var numberOfGuests: Int                = 0
    dynamic var checkinDate: String                = ""
    dynamic var checkoutDate: String               = ""
    dynamic var checkinDateText: String            = ""
    dynamic var checkoutDateText: String           = ""
    
    convenience init(info: SearchHotelInfo, searchAt searchTime: Date? = nil) {
        self.init()
        
        self.searchHotelInfo = info
        
        self.cityId = info.city!.id
        self.hotelName  = info.city!.name
        self.numberOfRooms = info.numberOfRooms
        self.numberOfGuests = info.numberOfGuest
        self.checkinDate = info.checkinDay!.toYYYYMMDDString()
        self.checkoutDate = info.checkoutDay!.toYYYYMMDDString()
        self.checkinDateText = info.checkinDay!.toFullMonthDay()
        self.checkoutDateText = info.checkoutDay!.toFullMonthDay()
    }
    
    required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        
    }
    
    func requestInfoFromSearch() -> SearchHotelInfo {
        if self.searchHotelInfo != nil {
            return self.searchHotelInfo!
        } else {
            self.searchHotelInfo = SearchHotelInfo()
            let realm = try! Realm()
            
            self.searchHotelInfo?.city = realm.object(ofType: City.self, forPrimaryKey: "\(self.cityId)")
            self.searchHotelInfo?.checkinDay = self.checkinDate.toYYYYMMDD()
            self.searchHotelInfo?.checkoutDay = self.checkoutDate.toYYYYMMDD()
            self.searchHotelInfo?.numberOfGuest = self.numberOfGuests
            self.searchHotelInfo?.numberOfRooms = self.numberOfRooms
            
            return self.searchHotelInfo!
        }
    }
}

