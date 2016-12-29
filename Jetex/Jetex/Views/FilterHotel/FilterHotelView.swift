//
//  FilterHotelView.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 12/25/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import TTRangeSlider

protocol FilterHotelViewDelegate: class {
    func hideFilter()
//    func applyFilter(filterObject: FilterObject)
}

class FilterHotelView: UIView {
    @IBOutlet var contentView: UIView!
    weak var delegate: FilterHotelViewDelegate?
    @IBOutlet weak var priceSlider: TTRangeSlider!
    @IBOutlet weak var imgCancel: UIImageView!
    @IBOutlet weak var starSlider: TTRangeSlider!
    @IBOutlet weak var userSlider: TTRangeSlider!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    // MARK: Initialization
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        Bundle.main.loadNibNamed("FilterHotelView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        
        self.setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("FilterHotelView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        
        self.setupViews()
    }
    
    @IBAction func hideFilter(_ sender: UIButton) {
        delegate?.hideFilter()
    }
    
    func setupViews() {
        // price slider
        self.priceSlider.delegate = self
        self.priceSlider.minValue = 0
        self.priceSlider.maxValue = 1000
        self.priceSlider.selectedMinimum = 0
        self.priceSlider.selectedMaximum = 1000
        self.priceSlider.step = 50
        self.priceSlider.handleColor = UIColor(hex: 0x674290)
        self.priceSlider.handleDiameter = 16
        self.priceSlider.selectedHandleDiameterMultiplier = 1.3
        self.priceSlider.tintColorBetweenHandles = UIColor(hex: 0x674290)
        self.priceSlider.tintColor = UIColor(hex: 0xD6D6D6)
        self.priceSlider.minLabelColour = UIColor(hex: 0x515151)
        self.priceSlider.maxLabelColour = UIColor(hex: 0x515151)
        
        let customFormatter = NumberFormatter()
        customFormatter.positivePrefix = ProfileVC.currentCurrencyType
        self.priceSlider.numberFormatterOverride = customFormatter
        
        // star slider
        self.starSlider.delegate = self
        self.starSlider.minValue = 1
        self.starSlider.maxValue = 5
        self.starSlider.selectedMinimum = 1
        self.starSlider.selectedMaximum = 5
        self.starSlider.step = 1
        self.starSlider.handleColor = UIColor(hex: 0x674290)
        self.starSlider.handleDiameter = 16
        self.starSlider.selectedHandleDiameterMultiplier = 1.3
        self.starSlider.tintColorBetweenHandles = UIColor(hex: 0x674290)
        self.starSlider.tintColor = UIColor(hex: 0xD6D6D6)

        // user slider
        self.userSlider.delegate = self
        self.userSlider.minValue = 3
        self.userSlider.maxValue = 10
        self.userSlider.selectedMinimum = 3
        self.userSlider.selectedMaximum = 10
        self.userSlider.step = 1
        self.userSlider.handleColor = UIColor(hex: 0x674290)
        self.userSlider.handleDiameter = 16
        self.userSlider.selectedHandleDiameterMultiplier = 1.3
        self.userSlider.tintColorBetweenHandles = UIColor(hex: 0x674290)
        self.userSlider.tintColor = UIColor(hex: 0xD6D6D6)
        
        imgCancel.image = UIImage(fromHex: JetExFontHexCode.jetexCross.rawValue, withColor: UIColor(hex: 0x515151))
        
        // collection view
        self.collectionView.register(UINib(nibName: "AmenityCell", bundle: nil), forCellWithReuseIdentifier: "AmenityCell")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        
    }
}

extension FilterHotelView: TTRangeSliderDelegate {
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        
    }
}

extension FilterHotelView: UICollectionViewDataSource {
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
        cell.imgView.image = UIImage(fromHex: amenity.1, withColor: (UIColor(hex: 0x674290)))
        
        return cell
    }
}

extension FilterHotelView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension FilterHotelView: UICollectionViewDelegateFlowLayout {
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
