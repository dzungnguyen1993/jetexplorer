//
//  MapFullScreenViewViewController.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/11/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import GoogleMaps
import PopupDialog

enum MapType {
    case cityMap, hotelMap
}

class MapFullScreenVC: BaseViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var delegate: HotelResultVCDelegate?
    
    var mapType: MapType!
    var markersList : [GMSMarker]!
    
    // Header
    var searchInfo: SearchHotelInfo!
    var hotel: Hotel?
    var searchHotelResult: SearchHotelResult?
    
    @IBOutlet weak var imgPassenger: UIImageView!
    @IBOutlet weak var imgRightArrow: UIImageView!
    @IBOutlet weak var viewDateDepart: SearchResultDateView!
    @IBOutlet weak var viewDateReturn: SearchResultDateView!
    @IBOutlet weak var viewRoundtrip: UIView!
    @IBOutlet weak var lbCity: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbGuest: UILabel!
    @IBOutlet weak var lbRoom: UILabel!
    
    @IBOutlet weak var imgCancel: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        let cityLocation = searchInfo.city?.getLatLong()
        var camera : GMSCameraPosition?
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        if (self.mapType == .cityMap) {
            // list all hotels in city
            marker.position = CLLocationCoordinate2D(latitude: (cityLocation?.0)!, longitude: (cityLocation?.1)!)
            camera = GMSCameraPosition.camera(withLatitude: (cityLocation?.0)!, longitude: (cityLocation?.1)!, zoom: 14.0)
            markersList = generateMarkersForHotelsAroundCenter(hotels: self.searchHotelResult!.hotels, for: mapView, centerLatitude: cityLocation!.0, centerLongitude: cityLocation!.1)
        } else {
            // show only hotel that is selected
            marker.position = CLLocationCoordinate2D(latitude: hotel!.latitude, longitude: hotel!.longitude)
            camera = GMSCameraPosition.camera(withLatitude: hotel!.latitude, longitude: hotel!.longitude, zoom: 18.0)
            
            marker.title = hotel!.name
            marker.snippet = searchInfo.city?.name
        }
        
        mapView.camera = camera!
        marker.map = mapView
        
        // set up header
        showHeaderInfo()
        setupImagesInHeader()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchHereButtonPressed(_ sender: Any) {
        let loadingVC = InitialLoadingPopupVC(nibName: "InitialLoadingPopupVC", bundle: nil)
        loadingVC.initView(title: "Searching...", message: "Please wait")
        
        let popUpVC = PopupDialog(viewController: loadingVC, buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
        self.present(popUpVC, animated: true, completion: nil)

        // get center of mapView
        let center = self.mapView.camera
        
        // remove all the markers on map
        self.mapView.clear()
        
        // search then add more marker around this center
        markersList = generateMarkersForHotelsAroundCenter(hotels: self.searchHotelResult!.hotels, for: self.mapView, centerLatitude: center.target.latitude, centerLongitude: center.target.longitude)
        
        popUpVC.dismiss()
    }
    
    @IBAction func exitMap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func generateMarkersForHotelsAroundCenter(hotels: [Hotel], for mapView: GMSMapView, centerLatitude: Double, centerLongitude: Double) -> [GMSMarker] {
        var result : [GMSMarker] = []
        
        let aroundHotels = hotels.filter { (hotel) -> Bool in
            return Utility.distance(lat1: hotel.latitude, lon1: hotel.longitude, lat2: centerLatitude, lon2: centerLongitude) < 10.0 // < 10km
        }
        
        for hotel in aroundHotels {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: hotel.latitude, longitude: hotel.longitude)
            marker.title = hotel.name
            
            if let agentPrice = self.searchHotelResult?.getPrice(ofHotel: hotel) {
                marker.snippet = ProfileVC.currentCurrencyType + " " + (agentPrice.priceTotal.toString())
            } else {
                marker.snippet = searchInfo.city?.name
            }
            
            marker.map = mapView
            marker.userData = hotel
            result.append(marker)
        }
        
        return result
    }
}

extension MapFullScreenVC : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print(marker.userData ?? "")
        if let selectedHotel = marker.userData as? Hotel {
            if mapType == .cityMap {
                // show popup
                let loadingVC = InitialLoadingPopupVC(nibName: "InitialLoadingPopupVC", bundle: nil)
                loadingVC.initView(title: "Loading...", message: "Loading detail information for the hotel")
                
                let popUpVC = PopupDialog(viewController: loadingVC, buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false, completion: nil)
                self.present(popUpVC, animated: true, completion: nil)
                
                //load detail first
                HotelResultVC.getHotelInfoInDetail(hotelId: selectedHotel.id) { (result) in
                    popUpVC.dismiss()
                    if let result = result {
                        let vc = HotelDetailsVC(nibName: "HotelDetailsVC", bundle: nil)
                        vc.searchInfo = self.searchInfo
                        vc.hotelInDetailResult = result
                        vc.pickedHotel = selectedHotel
                        
                        self.dismiss(animated: false, completion: {
                            self.delegate?.goToViewController(viewController: vc)
                        })
                        
                    } else {
                        let popUpVC = PopupDialog(title: "Fail", message: "Couldn't load detail information for the hotel, please try again!")
                        popUpVC.addButton(CancelButton(title: "Cancel", dismissOnTap: true, action: nil))
                        self.present(popUpVC, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    
    
}

extension MapFullScreenVC : ZoomTransitionProtocol {
    func viewForTransition() -> UIView {
        return self.mapView
    }

    func showHeaderInfo() {
        lbCity.text = searchInfo.city?.name
        let country = DBManager.shared.getCountry(fromCity: searchInfo.city!)
        lbCountry.text = country?.name
        viewDateDepart.lbDate.text = searchInfo.checkinDay?.toDay()
        viewDateDepart.lbMonth.text = searchInfo.checkinDay?.toMonth()
        viewDateReturn.lbDate.text = searchInfo.checkoutDay?.toDay()
        viewDateReturn.lbMonth.text = searchInfo.checkoutDay?.toMonth()
        lbGuest.text = searchInfo.numberOfGuest.toString()
        if (searchInfo.numberOfRooms == 1) {
            lbRoom.text = searchInfo.numberOfRooms.toString() + "room"
        } else {
            lbRoom.text = searchInfo.numberOfRooms.toString() + "rooms"
        }
        
        imgCancel.image = UIImage(fromHex: JetExFontHexCode.jetexCross.rawValue, withColor: UIColor(hex: 0x515151))
    }
    
    func setupImagesInHeader() {
        imgPassenger.image = UIImage(fromHex: JetExFontHexCode.jetexPassengers.rawValue, withColor: UIColor.white)
        imgRightArrow.image = UIImage(fromHex: JetExFontHexCode.oneWay.rawValue, withColor: UIColor.white)
    }
}
