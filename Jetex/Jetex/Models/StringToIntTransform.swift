//
//  StringToIntTransform.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/18/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import Foundation
import ObjectMapper


// TODO: implement it using the right format
open class StringToIntTransform: TransformType {
    public typealias Object = Int
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> Int? {
        if let intString = value as? String {
            return Int(intString)
        }
        return 0
    }
    
    open func transformToJSON(_ value: Int?) -> String? {
        return "\(value)"
    }
}
