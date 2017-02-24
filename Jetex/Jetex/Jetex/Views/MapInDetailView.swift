//
//  MapInDetailView.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/10/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import AlamofireImage

class MapInDetailView: UIView {

    static let height : CGFloat = 370.0
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var staticMapImageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var delegate : HotelDetailsVCDelegate?
    var width : CGFloat = 0.0
    
    func initView() {
        Bundle.main.loadNibNamed("MapInDetailView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MapInDetailView.zoomMapToFullScreen))
        self.contentView.addGestureRecognizer(tapGesture)
    }
    
    // using static picture to boost the perfomance
    func initMap(withWidth: CGFloat) {
        width = withWidth
        self.staticMapImageView.image = UIImage(named: "staticMap")
    }
    
    func bindingData(hotelInfo: HotelinDetail) {
        // create URL
        var staticMapUrl: String = APIURL.GoogleAPI.staticMapBaseURL + "?"
        staticMapUrl += "center=\(hotelInfo.latitude),\(hotelInfo.longitude)" + "&"
        staticMapUrl += "zoom=12" + "&"
        staticMapUrl += "size=\(Int(width))x\(Int(MapInDetailView.height))" + "&"
        staticMapUrl += "markers=color:blue|label:\(hotelInfo.name.characters.first!)|\(hotelInfo.latitude),\(hotelInfo.longitude)" + "&"
        staticMapUrl += "key=\(APIURL.GoogleAPI.mapKey)"
        
        let mapUrl = URL(string: staticMapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        loadingIndicator.startAnimating()
        
        // load image
        Alamofire.request(mapUrl).responseImage { response in
            // stop then hide the indicator
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            
            if let image = response.result.value {
                self.staticMapImageView.image = image
            } else {
                self.staticMapImageView.isHidden = true
                self.mapView.isHidden = false
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    func zoomMapToFullScreen() {
        delegate?.zoomMapToFullScreen()
    }
    
    
}
