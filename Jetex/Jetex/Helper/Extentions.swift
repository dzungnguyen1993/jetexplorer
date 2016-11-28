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
    
    func toYYYYMMDDString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let timeString = formatter.string(from: self)
        
        return timeString
    }
    
    func howlongago(numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = NSDate()
        let date = NSDate(timeIntervalSince1970: self.timeIntervalSince1970)
        let earliest = (now as NSDate).earlierDate(self)
        let latest = (earliest.timeIntervalSince1970 == now.timeIntervalSince1970) ? date : now
        
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest as Date, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
    
    static func shorterlizeFullMonthDay(_ string: String) -> String {
        let first = string.substring(to: string.characters.index(string.startIndex, offsetBy: 3))
        let last = string.substring(from: string.characters.index(of: " ")!)
        return first + last
    }
   
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from: self)
        
        //Return Short Time String
        return timeString
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

extension Int {
    func toString() -> String {
        return String(self)
    }
    
    func toHourAndMinute() -> String {
        let hour = self / 60
        let minute = self % 60
        
        if (minute > 0) {
            return hour.toString() + "h " + minute.toString() + "m"
        }
        return hour.toString() + "h"
    }
}

extension String {
    func toDateTimeUTC() -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        //Parse into NSDate
        let dateFromString : Date = dateFormatter.date(from: self)!
        
        //Return Parsed Date
        return dateFromString
    }
}
