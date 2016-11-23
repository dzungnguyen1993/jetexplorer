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
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        email <- map["email"]
        username              <- map["username"]
        displayName <- map["displayName"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        provider <- map["provider"]
        currency <- map["currency"]
        profileURL <- map["profileImageURL"]
    }
}
