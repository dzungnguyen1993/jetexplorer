//
//  NetworkManager.swift
//  HospitalCheckin
//
//  Created by Thanh-Dung Nguyen on 11/21/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import PopupDialog
import AlamofireObjectMapper

enum RequestType: String {
    case getAllAirport = "/flights/api/get/all_airport_sky"
    case getFlightSearchResult = "/flights/api/search-new"
    case getHotelSearchResult = "/hotels/api/search-sky"
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
    
    func requestGetFlightSearchResult(info: PassengerInfo, currentPopUp: PopupDialog? = nil, completion: ResponseCompletion? = nil) {
        //:country/:currency/:locale/:originplace/:destinationplace/:outbounddate/:inbounddate/:adults/:children/:infants/:cabinclass
        //UK/USD/en-GB/SGN/HAN/2016-11-10/2016-11-11/1/1/1/Economy
        
        guard (info.airportFrom != nil && info.airportTo != nil && info.departDay != nil && info.returnDay != nil) else {
            completion?(false, nil)
            return
        }
        
        // create request string
        var requestString = hostAddress + RequestType.getFlightSearchResult.rawValue
        requestString.append("/UK/" + ProfileVC.currentCurrencyType + "/en-GB")
        
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
        let adult = info.passengers[PassengerType.adult.rawValue].value //+ info.passengers[PassengerType.senior.rawValue].value
        requestString.append("/" + adult.toString())
  
        // add children
        requestString.append("/" + info.passengers[PassengerType.children.rawValue].value.toString())
        
        // add infant
        let infant = info.passengers[PassengerType.infant.rawValue].value //+ info.passengers[PassengerType.lapInfant.rawValue].value
        requestString.append("/" + infant.toString())
        
        // add cabin class
        let cabinClass = info.flightClass.deleteAllSpace()
        requestString.append("/" + cabinClass)
        
        let parameters = Parameters()
        
        print(requestString)
        Alamofire.request(requestString, method: .get, parameters: parameters).responseJSON { (response) in
            completion?(response.result.isSuccess, response.result.value)
        }
    }
    
    // Sync history
    func syncHistoryToServer (historyData: [[String: Any]], atView: UIViewController? = nil, showPopup: Bool = true, completion: ((_ success: Bool, _ searchHistory: List<HistorySearch>?) -> Void)?) {
        var popup: PopupDialog? = nil
        if showPopup {
            // Show Loading Pop up view
            popup = PopupDialog(title: "Syncing...", message: "We are syncing your data, Please wait!", image: nil, buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
            
            atView?.present(popup!, animated: true, completion: nil)
        }
        
        func onErrorOcurs() {
            if let completion = completion {
                completion(false, nil)
            } else if showPopup {
                let newPopup = PopupDialog(title: "Cannot sync", message: "Please check your internet connection.", image: nil)
                newPopup.addButton(CancelButton(title: "Try again", action: nil))
                atView?.present(newPopup, animated: true, completion: nil)
            }
        }
        
        // sync with server
        let request = APIURL.JetExAPI.base + APIURL.JetExAPI.history
        let parameter : Parameters = ["listHistorySearch" : historyData ]
        
        Alamofire.request(request, method: .post, parameters: parameter, encoding: JSONEncoding.default).responseObject { (response: DataResponse<User>) in
            if let currentUser = response.result.value {
                print(currentUser)
                // update this user is current user
                currentUser.isCurrentUser = true
                
                // success get user info
                let realm = try! Realm()
                
                // get the current user
                if let lastUser = realm.objects(User.self).filter("isCurrentUser == true").first {
                    if lastUser.id == currentUser.id {
                        // same user login, nothing happen
                    } else {
                        // set it to not be
                        try! realm.write{
                            lastUser.isCurrentUser = false
                        }
                    }
                }
                
                // save/update it to Realm
                try! realm.write {
                    realm.add(currentUser, update: true)
                }
                
                if showPopup {
                    popup?.dismiss({
                        if let completion = completion {
                            completion(true, currentUser.searchesHistory)
                        }
                    })
                } else {
                    if let completion = completion {
                        completion(true, currentUser.searchesHistory)
                    }
                }
            } else {
                if showPopup {
                    popup?.dismiss({
                        onErrorOcurs()
                    })
                } else {
                    onErrorOcurs()
                }
            }
        }
    }

    // Search hotel
    func requestGetHotelSearchResult(info: SearchHotelInfo, completion: @escaping ResponseCompletion) {
        ///hotels/api/search-sky/:market/:currency/:locale/:place/:dateIn/:dateOut/:adults/:rooms/:imageLimit/:pageSize
        //http://jetexplorer.com/hotels/api/search-sky/UK/AUD/en-GB/bangkok/2016-12-30/2017-01-04/4/2/1/200
        
        // create request string
        var requestString = hostAddress + RequestType.getHotelSearchResult.rawValue
        requestString.append("/UK/" +  ProfileVC.currentCurrencyType + "/en-GB")
        
        // add place
        requestString.append("/" + (info.city?.name)!)
        
        // add check in
        requestString.append("/" + (info.checkinDay?.toYYYYMMDDString())!)
        
        // add check out
        requestString.append("/" + (info.checkoutDay?.toYYYYMMDDString())!)
        
        // add number of guests
        requestString.append("/" + info.numberOfGuest.toString())
        
        // add rooms
        requestString.append("/" + info.numberOfRooms.toString())
        
        // add image limit
        requestString.append("/" + "1")
        
        // add page size
        requestString.append("/" + "10")
        
        let parameters = Parameters()
        
        print(requestString)
        Alamofire.request(requestString, method: .get, parameters: parameters).responseJSON { (response) in
            completion(response.result.isSuccess, response.result.value)
        }
    }
    
    // Hotel details
}
