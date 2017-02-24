//
//  User.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/23/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

/* JSON Response
 {
 "__v": 0,
 "displayName": "",
 "provider": "local",
 "email": "hosiduy19@gmail.com",
 "_id": "582fda2cf75db0300231e82d",
 "currency": "USD",
 "created": "2016-11-19T04:50:52.394Z",
 "roles": [
    "user"
    ],
 "profileImageURL": "modules/users/client/img/profile/default.png",
 "username": "hosiduy19@gmail.com",
 "lastName": "",
 "firstName": ""
 }
 */

class User: Object, Mappable {
    dynamic var id: String = ""
    dynamic var email: String = ""
    dynamic var username: String = ""
    dynamic var displayName: String? = ""
    dynamic var firstName: String? = ""
    dynamic var lastName: String? = ""
    dynamic var provider: String = ""
    dynamic var currency: String = ""
    dynamic var profileURL: String = ""
    dynamic var isCurrentUser : Bool = false
    
    var searchesHistory = List<HistorySearch>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id              <- map["_id"]
        email           <- map["email"]
        username        <- map["username"]
        displayName     <- map["displayName"]
        firstName       <- map["firstName"]
        lastName        <- map["lastName"]
        provider        <- map["provider"]
        currency        <- map["currency"]
        profileURL      <- map["profileImageURL"]
        searchesHistory <- (map["listHistorySearch"], ListTransform<HistorySearch>())
    }
}

/*
 {"_id":"580d90fc30a7430374feba6b","displayName":"","provider":"local","email":"hosiduy@gmail.com","__v":5,
 "listHistorySearch":[
 {"createTime":"Sat Nov 19 2016 12:19:27 GMT+0700 (ICT)","arrivalAirport":"SGN","departAirport":"HAN","class":"","flightType":"Round Trip","infant":0,"children":0,"adult":1,"returnDate":"2016-11-20","departDate":"2016-11-19","arrivalCity":"Ho Chi Minh City","departCity":"Hanoi","dataType":"flight"},
 {"returnDateText":"November 19","departDateText":"November 18","createTimeText":"November 18, 2016","createTime":"Fri Nov 18 2016 13:53:56 GMT+0700 (ICT)","arrivalAirport":"HAN","departAirport":"SGN","class":"","flightType":"Round Trip","infant":0,"children":0,"adult":1,"returnDate":"2016-11-19","departDate":"2016-11-18","arrivalCity":"Hanoi","departCity":"Ho Chi Minh City","dataType":"flight"},{"returnDateText":"November 20","departDateText":"November 19","createTimeText":"November 19, 2016","createTime":"Sat Nov 19 2016 12:17:47 GMT+0700 (ICT)","arrivalAirport":"HAN","departAirport":"SGN","class":"","flightType":"Round Trip","infant":0,"children":0,"adult":1,"returnDate":"2016-11-20","departDate":"2016-11-19","arrivalCity":"Hanoi","departCity":"Ho Chi Minh City","dataType":"flight"},{"returnDateText":"November 19","departDateText":"November 18","createTimeText":"November 18, 2016","createTime":"Fri Nov 18 2016 13:53:56 GMT+0700 (ICT)","arrivalAirport":"HAN","departAirport":"SGN","class":"","flightType":"Round Trip","infant":0,"children":0,"adult":1,"returnDate":"2016-11-19","departDate":"2016-11-18","arrivalCity":"Hanoi","departCity":"Ho Chi Minh City","dataType":"flight"},{"returnDateText":"November 19","departDateText":"November 18","createTimeText":"November 18, 2016","createTime":"Fri Nov 18 2016 13:53:56 GMT+0700 (ICT)","arrivalAirport":"HAN","departAirport":"SGN","class":"","flightType":"Round Trip","infant":0,"children":0,"adult":1,"returnDate":"2016-11-19","departDate":"2016-11-18","arrivalCity":"Hanoi","departCity":"Ho Chi Minh City","dataType":"flight"
 }],"currency":"AUD","created":"2016-10-24T04:41:32.234Z","roles":["user"],"profileImageURL":"modules/users/client/img/profile/default.png","username":"hosiduy@gmail.com","lastName":"","firstName":""}
 */
