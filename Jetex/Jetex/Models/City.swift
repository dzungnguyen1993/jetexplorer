//
//  City.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/10/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class City: NSObject {
    var cityName: String
    var countryName: String
    var countryID: String!
    
    init(cityName: String, countryName: String, countryID: String! = nil){
        self.cityName = cityName
        self.countryName = countryName
        self.countryID = countryID
    }
}
