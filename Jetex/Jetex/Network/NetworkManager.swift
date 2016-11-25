//
//  NetworkManager.swift
//  HospitalCheckin
//
//  Created by Thanh-Dung Nguyen on 11/21/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import Alamofire

enum RequestType: String {
    case getAllAirport = "/flights/api/get/all_airport_sky"
    
}

class NetworkManager: NSObject {
    typealias ResponseCompletion = ((_ isSuccess: Bool, _ response: Any?) -> Void)
    
    let hostAddress = "https://jetexplorer.com"
    
    static let shared = NetworkManager()
    
    private override init() {
        
    }
    
    func requestGET(typeOf type: RequestType, parameters: Parameters, completion: @escaping ResponseCompletion) {
        let requestString = hostAddress + type.rawValue
        
        Alamofire.request(requestString, method: .get, parameters: parameters).responseJSON { (response) in
            completion(response.result.isSuccess, response.result.value)
        }
    }
    
    func requestGetAllAirport(completion: @escaping ResponseCompletion) {
        let parameters = Parameters()
        requestGET(typeOf: .getAllAirport, parameters: parameters, completion: completion)
        
        
    }
}
