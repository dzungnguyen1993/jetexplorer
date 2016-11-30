//
//  Currency.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/30/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Currency: Mappable {
    dynamic var code: String = ""
    dynamic var symbol: String = ""
    dynamic var thousandsSeparator: String = ""
    dynamic var decimalSeparator: String = ""
    dynamic var symbolOnLeft: Bool = false
    dynamic var spaceBetweenAmountAndSymbol: Bool = false
    dynamic var roundingCoefficient: Int = 0
    dynamic var decimalDigits: Int = 2
    
    required convenience init?(map: Map) {
        self.init()
    }
//    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
    
    func mapping(map: Map) {
        code <- map["Code"]
        symbol <- map["Symbol"]
        thousandsSeparator <- map["ThousandsSeparator"]
        decimalSeparator <- map["DecimalSeparator"]
        symbolOnLeft <- map["SymbolOnLeft"]
        spaceBetweenAmountAndSymbol <- map["SpaceBetweenAmountAndSymbol"]
        roundingCoefficient <- map["RoundingCoefficient"]
        decimalDigits <- map["DecimalDigits"]
    }

}
