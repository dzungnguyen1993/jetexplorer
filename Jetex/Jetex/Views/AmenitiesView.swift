//
//  AmenitiesView.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/10/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class AmenitiesView: UIView {

    static let height : CGFloat = 548.0
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var amenitiesCollectionView: UICollectionView!
    // - Mock up
    var amenities = [("24-hour front desk", JetExFontHexCode.jetexAmenities24h.rawValue),
                     ("Luggate storage", JetExFontHexCode.jetexAmenitiesLuggage.rawValue),
                     ("Babysitting or childcare", JetExFontHexCode.jetexAmenitiesChildcare.rawValue),
                     ("Free WiFi", JetExFontHexCode.jetexAmenitiesWifi.rawValue),
                     ("Coffee shop or café", JetExFontHexCode.jetexAmenitiesCoffee.rawValue),
                     ("Breakfast available (surcharge)", JetExFontHexCode.jetexAmenitiesBreakfast.rawValue),
                     ("Full-service spa", JetExFontHexCode.jetexAmenitiesSpa.rawValue),
                     ("Fitness facilities", JetExFontHexCode.jetexAmenitiesGym.rawValue),
                     ("ATM/banking", JetExFontHexCode.jetexAmenitiesATM.rawValue),
                     ("Outdoor pool", JetExFontHexCode.jetexAmenitiesPool.rawValue),
                     ("Casino", JetExFontHexCode.jetexAmenitiesCasino.rawValue),
                     ("Dry cleaning/ laundry service", JetExFontHexCode.jetexAmenitiesLaundry.rawValue),
                     ("Limo or Town Car service available", JetExFontHexCode.jetexAmenitiesCar.rawValue),
                     ("Elevator/lift", JetExFontHexCode.jetexAmenitiesElevator.rawValue)]
    
    
    func initView() {
        Bundle.main.loadNibNamed("AmenitiesView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        
        setUpAnemitiesSection()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    
    func setUpAnemitiesSection() {
        
        // collection view
        self.amenitiesCollectionView.register(UINib(nibName: "AmenityCell", bundle: nil), forCellWithReuseIdentifier: "AmenityCell")
        self.amenitiesCollectionView.delegate = self
        self.amenitiesCollectionView.dataSource = self
    }
}

// MARK: Set up Collection of Amenities

extension AmenitiesView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amenities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AmenityCell", for: indexPath) as! AmenityCell
        
        let amenity = self.amenities[indexPath.row]
        cell.label.text = amenity.0
        cell.label.textColor = UIColor(hex: 0x674290)
        cell.imgView.image = UIImage(fromHex: amenity.1, withColor: (UIColor(hex: 0x674290)))
        
        return cell
    }
}

extension AmenitiesView: UICollectionViewDelegate {
}

extension AmenitiesView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: 76)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
