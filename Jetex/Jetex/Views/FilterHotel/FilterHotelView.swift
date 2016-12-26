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
    
    // MARK: Initialization
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        Bundle.main.loadNibNamed("FilterHotelView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
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
        self.priceSlider.delegate = self
        self.priceSlider.minValue = 50
        self.priceSlider.maxValue = 150
        self.priceSlider.selectedMinimum = 50
        self.priceSlider.selectedMaximum = 150
        self.priceSlider.handleColor = UIColor(hex: 0x674290)
        self.priceSlider.handleDiameter = 30
        self.priceSlider.selectedHandleDiameterMultiplier = 1.3
        let customFormatter = NumberFormatter()
        customFormatter.positivePrefix = ProfileVC.currentCurrencyType
        self.priceSlider.numberFormatterOverride = customFormatter
    }
}

extension FilterHotelView: TTRangeSliderDelegate {
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        
    }
}
