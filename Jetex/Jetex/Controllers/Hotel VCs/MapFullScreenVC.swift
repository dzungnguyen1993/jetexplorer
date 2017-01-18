//
//  MapFullScreenViewViewController.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/11/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import GoogleMaps

class MapFullScreenVC: BaseViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    // Header
    var searchInfo: SearchHotelInfo!
    
    @IBOutlet weak var imgPassenger: UIImageView!
    @IBOutlet weak var imgRightArrow: UIImageView!
    @IBOutlet weak var viewDateDepart: SearchResultDateView!
    @IBOutlet weak var viewDateReturn: SearchResultDateView!
    @IBOutlet weak var viewRoundtrip: UIView!
    @IBOutlet weak var lbCity: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbGuest: UILabel!
    @IBOutlet weak var lbRoom: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let cityLocation = searchInfo.city?.getLatLong()
        let camera = GMSCameraPosition.camera(withLatitude: (cityLocation?.0)!, longitude: (cityLocation?.1)!, zoom: 13.0)
        mapView.camera = camera
        
        // Creates a marker in the center of the map.
        // TODO: create marker with hotel info
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: (cityLocation?.0)!, longitude: (cityLocation?.1)!)
        marker.title = searchInfo.city?.name//"Sydney"
        let country = DBManager.shared.getCountry(fromCity: searchInfo.city!)
        marker.snippet = country?.name//"Australia"
        marker.map = mapView
        
        // set up header
        showHeaderInfo()
        setupImagesInHeader()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    
    func setupImagesInHeader() {
        imgPassenger.image = UIImage(fromHex: JetExFontHexCode.jetexPassengers.rawValue, withColor: UIColor.white)
        imgRightArrow.image = UIImage(fromHex: JetExFontHexCode.oneWay.rawValue, withColor: UIColor.white)
    }
}
