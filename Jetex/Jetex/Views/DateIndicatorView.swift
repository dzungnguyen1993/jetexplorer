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
        let strokeColor = UIColor(hex: 0xEFEFEF)
        let fillColor = UIColor(hex: 0xF6F6F6)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0,y: 8))
        path.addLine(to: CGPoint(x: xIndicator, y: 8))
        path.addLine(to: CGPoint(x: xIndicator + 7, y: 0))
        path.addLine(to: CGPoint(x: xIndicator + 14, y: 8))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 8))
        
        path.move(to: CGPoint(x: 0, y: self.frame.size.height-1))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height-1))
        fillColor.setFill()
        path.fill()
        strokeColor.setStroke()
        path.lineWidth = 1
        path.stroke()
    }
}
