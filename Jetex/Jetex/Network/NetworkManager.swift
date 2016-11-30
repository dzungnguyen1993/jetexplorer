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
    case getFlightSearchResult = "/flights/api/search-new"
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
    
    func requestGetFlightSearchResult(info: PassengerInfo, completion: @escaping ResponseCompletion) {
        //:country/:currency/:locale/:originplace/:destinationplace/:outbounddate/:inbounddate/:adults/:children/:infants/:cabinclass
        //UK/USD/en-GB/SGN/HAN/2016-11-10/2016-11-11/1/1/1/Economy
        
        // create request string
        var requestString = hostAddress + RequestType.getFlightSearchResult.rawValue
        requestString.append("/UK/USD/en-GB")
        
        // add origin
        requestString.append("/" + (info.airportFrom?.id)!)
        
        // add destination
        requestString.append("/" + (info.airportTo?.id)!)
        
        // add depart day
        requestString.append("/" + (info.departDay?.toYYYYMMDDString())!)
        
        // add return day
        if (info.isRoundTrip) {
            requestString.append("/" + (info.returnDay?.toYYYYMMDDString())!)
        } else {
            requestString.append("/" + "0")
        }

        // add adult
        let adult = info.passengers[PassengerType.adult.rawValue].value + info.passengers[PassengerType.senior.rawValue].value
        requestString.append("/" + adult.toString())
  
        // add children
        requestString.append("/" + info.passengers[PassengerType.children.rawValue].value.toString())
        
        // add infant
        let infant = info.passengers[PassengerType.infant.rawValue].value + info.passengers[PassengerType.lapInfant.rawValue].value
        requestString.append("/" + infant.toString())
        
        // add cabin class
        requestString.append("/" + "Economy")
        
        let parameters = Parameters()
        
        print(requestString)
        Alamofire.request(requestString, method: .get, parameters: parameters).responseJSON { (response) in
            completion(response.result.isSuccess, response.result.value)
        }
    }
}
