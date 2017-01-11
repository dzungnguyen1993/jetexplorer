//
//  MenuButtonType.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/9/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import Foundation

enum MenuButtonType : Int {
    case Deals = 0
    case Reviews = 1
    case Map = 2
    case Amenities = 3
    
    func getString() -> String {
        switch self {
        case .Deals:
            return "Deals"
        case .Reviews:
            return "Reviews"
        case .Map:
            return "Map"
        case .Amenities:
            return "Amenities"
        }
    }
}
