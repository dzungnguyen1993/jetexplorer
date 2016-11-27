//
//  ResponseParser.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/27/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class ResponseParser {
    static let shared = ResponseParser()
    
    private init() {
        
    }
    
    func parseFlightSearchResponse(data: NSDictionary) {
        var result: SearchFlightResult = SearchFlightResult(JSON: data as! [String: Any])!
        
        
        print("aaa")
        
    }
}
