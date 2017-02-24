//
//  Airport.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/24/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Airport: Object, Mappable {
    dynamic var id: String = "" {
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    dynamic var name: String = ""{
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    dynamic var cityId: String = ""
    dynamic var countryId: String = ""
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
    
    func mapping(map: Map) {
        id <- map["Id"]
        name <- map["Name"]
        cityId <- map["CityId"]
        countryId <- map["CountryId"]
    }

    
    public func setCompoundID(id: String) {
        self.id = id
        compoundKey = compoundKeyValue()
    }
    
    
    public func setCompoundType(name: String) {
        self.name = name
        compoundKey = compoundKeyValue()
    }
    
    public dynamic var compoundKey: String = "0-"
    public override static func primaryKey() -> String? {
        return "compoundKey"
    }
    
    private func compoundKeyValue() -> String {
        return "\(id)-\(name)"
    }
}
