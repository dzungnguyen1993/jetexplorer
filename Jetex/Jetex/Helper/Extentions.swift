//
//  Extentions.swift
//  JetEx
//
//  Created by Nguyen Van Cuong on 5/30/16.
//  Copyright © 2016 Le Thanh Tan. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
}

extension UIButton{
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
            layer.borderWidth = 1
        }
    }
}

extension Date {
    func toMonthDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        let timeString = formatter.string(from: self)
        
        return timeString
    }
    
    func toWeekDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let timeString = formatter.string(from: self)
        
        return timeString
    }
}
