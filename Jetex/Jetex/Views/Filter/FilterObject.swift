//
//  FilterObject.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/30/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class FilterObject: NSObject {
    var stopType: StopCheckType = .any
    var checkedCarriers: [Int] = [Int]()
    
    var checkedOrigin: [Airport] = [Airport]()
    var checkedDestination: [Airport] = [Airport]()
    
    func copyFilter() -> FilterObject {
        let filterObject = FilterObject()
        filterObject.stopType = self.stopType
        
        for checkedIndex in self.checkedCarriers {
            filterObject.checkedCarriers.append(checkedIndex)
        }
        
        for airport in self.checkedOrigin {
            filterObject.checkedOrigin.append(airport)
        }
        
        for airport in self.checkedDestination {
            filterObject.checkedDestination.append(airport)
        }
        
        return filterObject
    }
}
