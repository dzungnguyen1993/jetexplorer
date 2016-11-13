//
//  DateIndicatorView.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/12/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class DateIndicatorView: UIView {

    var xIndicator: CGFloat = 100
    
    override func awakeFromNib() {
        
    }
    
    override func draw(_ rect: CGRect) {
        DateIndicatorStyleKit.drawDateIndicator(xIndicator: xIndicator, indFrame: rect.insetBy(dx: 0, dy: 0))
    }
}
