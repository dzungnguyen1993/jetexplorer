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

    static let height : CGFloat = 300.0
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var staticMapImageView: UIImageView!
    
    var delegate : HotelDetailsVCDelegate?
    
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
        // create URL
        var staticMapUrl: String = APIURL.GoogleAPI.staticMapBaseURL + "?"
        staticMapUrl += "center=\(63.259591),\(-144.667969)" + "&"
        staticMapUrl += "zoom=6" + "&"
        staticMapUrl += "size=\(Int(withWidth))x\(Int(MapInDetailView.height))" + "&"
        staticMapUrl += "markers=color:blue|label:H|\(63.259591),\(-144.667969)" + "&"
        staticMapUrl += "key=\(APIURL.GoogleAPI.mapKey)"
        
        let mapUrl = URL(string: staticMapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
        // load image
        Alamofire.request(mapUrl).responseImage { response in
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
