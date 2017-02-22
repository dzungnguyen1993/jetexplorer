//
//  JetExFontHexCode.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import Foundation

enum JetExFontHexCode : String{
    case profileEmpty            = "\u{e942}"
    case profileFulfill          = "\u{e941}"
    
    case planeEmpty              = "\u{e921}"
    case planeFulfill            = "\u{e91e}"
    
    case historyEmpty            = "\u{e916}"
    case historyFulfill          = "\u{e92d}"
    
    case exchange                = "\u{e913}"
    case oneWay                  = "\u{e917}"
    
    case bedEmpty                = "\u{e905}"
    case bedFulfill              = "\u{e904}"
    
    case jetexPin                = "\u{e91d}"
    
    case jetexCheckin            = "\u{e909}"
    case jetexCheckout           = "\u{e90b}"
    case jetexPassengers         = "\u{e91b}"
    case jetexChevronLeft        = "\u{e90c}"
    
    case jetexSliders            = "\u{e924}"
    case jetexCross              = "\u{e912}"
    
    case facebookIcon            = "\u{e940}"
    case googleIcon              = "\u{e932}"
    
    case jetexClock              = "\u{e90f}"
    
    case jetexMapFulfill         = "\u{e919}"
    case jetexMap                = "\u{e91a}"
    
    case jetexStarFulfill        = "\u{e927}"
    case jetexStarHalfFulfill    = "\u{e928}"
    
    case jetexAmenitiesDefault   = "" //"\u{e947}"
    case jetexAmenities24h       = "\u{e92e}"
    case jetexAmenitiesLuggage   = "\u{e939}"
    case jetexAmenitiesChildcare = "\u{e933}"
    case jetexAmenitiesWifi      = "\u{e93c}"
    case jetexAmenitiesCoffee    = "\u{e934}"
    case jetexAmenitiesBreakfast = "\u{e930}"
    case jetexAmenitiesSpa       = "\u{e93b}"
    case jetexAmenitiesHairSalon = "\u{e937}"
    case jetexAmenitiesGym       = "\u{e936}"
    case jetexAmenitiesATM       = "\u{e92f}"
    case jetexAmenitiesPool      = "\u{e93a}"
    case jetexAmenitiesCasino    = "\u{e943}"
    case jetexAmenitiesLaundry   = "\u{e938}"
    case jetexAmenitiesCar       = "\u{e931}"
    case jetexAmenitiesElevator  = "\u{e935}"
    
    public static func amenityCodeFromKey(key: String) -> String {
        switch key {
        case "SHUTTLESERVICE", "AIRPORTSHUTTLESERVICE", "PARKING", "PARKINGANDTRANSPORT", "LIMOUSINESERVICE", "CARRENTAL":
            return JetExFontHexCode.jetexAmenitiesCar.rawValue
        case "WIFISERVICE", "INTERNET", "INTERNETACCESSSERVICE":
            return JetExFontHexCode.jetexAmenitiesWifi.rawValue
        case "LAUNDRY":
            return JetExFontHexCode.jetexAmenitiesLaundry.rawValue
        case "LIFT":
            return JetExFontHexCode.jetexAmenitiesElevator.rawValue
        case "FRONTDESK24HSERVICE", "ROOMSERVICE", "DESK":
            return JetExFontHexCode.jetexAmenities24h.rawValue
        case "EXPRESSCHECKINSERVICE", "EXPRESSCHECKOUTSERVICE", "LUGGAGESTORAGE":
            return JetExFontHexCode.jetexAmenitiesLuggage.rawValue
        case "FITNESSCENTER", "HEALTHANDFITNESS", "GYMNASIUM":
            return JetExFontHexCode.jetexAmenitiesGym.rawValue
        case "INDOORSWIMMINGPOOL", "OUTDOORSWIMMINGPOOL", "POOLBAR", "CHILDRENPOOL":
            return JetExFontHexCode.jetexAmenitiesPool.rawValue
        case "BABYSITTINGSERVICE", "CHILDRENFACILITY":
            return JetExFontHexCode.jetexAmenitiesChildcare.rawValue
        case "SPA", "BEAUTYSALON":
            return JetExFontHexCode.jetexAmenitiesSpa.rawValue
        case "BILLIARDS":
            return JetExFontHexCode.jetexAmenitiesCasino.rawValue
        case "COFFEEMAKER", "MINIBAR", "LOUNGE":
            return JetExFontHexCode.jetexAmenitiesCoffee.rawValue
        case "RESTAURANT":
            return JetExFontHexCode.jetexAmenitiesBreakfast.rawValue
        case "CURRENCYEXCHANGESERVICE":
            return JetExFontHexCode.jetexAmenitiesATM.rawValue
        default:
            return JetExFontHexCode.jetexAmenitiesDefault.rawValue
        }
    }

}
