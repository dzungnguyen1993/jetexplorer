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
    var result: SearchFlightResult!
    
    private init() {
        result = SearchFlightResult()
    }
    
    func parseFlightSearchResponse(data: NSDictionary) -> SearchFlightResult {
        self.result = SearchFlightResult(JSON: data as! [String: Any])!
        return self.result
    }
}
