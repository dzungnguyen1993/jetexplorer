//
//  FilterHotelObject.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 1/1/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class FilterHotelObject: NSObject {
    var minPrice: Float = 0
    var maxPrice: Float = 0
    var minStar: Float = 0
    var maxStar: Float = 0
    var minRating: Float = 0
    var maxRating: Float = 0
    // contains id of selected amenities
    var selectedAmenities: [Int] = [Int]()
    
    func copyFilter() -> FilterHotelObject {
        let filterObject = FilterHotelObject()
        
        filterObject.minPrice = self.minPrice
        filterObject.maxPrice = self.maxPrice
        filterObject.minStar = self.minStar
        filterObject.maxStar = self.maxStar
        filterObject.minRating = self.minRating
        filterObject.maxRating = self.maxRating
        
        filterObject.selectedAmenities = [Int]()
        for selectedIndex in self.selectedAmenities {
            filterObject.selectedAmenities.append(selectedIndex)
        }
        
        return filterObject
    }
}
