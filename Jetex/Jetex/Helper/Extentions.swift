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

extension UIImage {
    func resize(newSize: (width: Int, height: Int)) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: newSize.width, height: newSize.height), false, 0.0);
        self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    convenience init(fromLabel: UILabel) {
        UIGraphicsBeginImageContextWithOptions(fromLabel.bounds.size, false, 0.0)
        fromLabel.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.init(cgImage: img!.cgImage!)
    }
    
    convenience init(fromHex: UnsafePointer<Int8>, withColor: UIColor = .darkGray) {
        let textlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        textlabel.font = UIFont(name: "JetExplorer", size: 36.0)
        textlabel.textColor = withColor
        textlabel.adjustsFontSizeToFitWidth = true
        
        textlabel.text = "\(NSString.init(utf8String: fromHex)!)"
        
        self.init(fromLabel: textlabel)
    }
    
    static func generateTabBarImageFromHex(fromHex: UnsafePointer<Int8>) -> UIImage {
        return UIImage(fromHex: fromHex).resize(newSize: (width: 24, height: 24))
    }
}

extension UILabel {
    func resizeToFitText() {
        self.numberOfLines = 0
        self.sizeToFit()
    }
}

extension Date {
    func toMonthDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let timeString = formatter.string(from: self)
        
        return timeString
    }
    
    func toWeekDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let timeString = formatter.string(from: self)
        
        return timeString
    }
    
    func toMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        let timeString = formatter.string(from: self)
        
        return timeString
    }
    
    func toDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let timeString = formatter.string(from: self)
        
        return timeString
    }
    
    func toNumberOnly() -> String {
        let forrmater = DateFormatter()
        forrmater.dateFormat = "yyyy-MM-dd"
        let timeString = forrmater.string(from: self)
        
        return timeString
    }
    
    func toFullMonthDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        let timeString = formatter.string(from: self)
        
        return timeString
    }
    
    func toFullMonthDayAndYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        let timeString = formatter.string(from: self)
        
        return timeString
    }
    
    static func shorterlizeFullMonthDay(_ string: String) -> String {
        let first = string.substring(to: string.characters.index(string.startIndex, offsetBy: 3))
        let last = string.substring(from: string.characters.index(of: " ")!)
        return first + last
    }
}

@IBDesignable extension UIView {
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}
