//
//  EPCalendarCell1.swift
//  EPCalendar
//
//  Created by Prabaharan Elangovan on 09/11/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit

enum DateCellStyle {
    case CheckInDate, DateBetweenCheckInAndOutDate, CheckOutDate, None
}

class EPCalendarCell1: UICollectionViewCell {

    @IBOutlet weak var lblDay: MediumParagraphLabel!
    var currentDate: Date!
    var currentDateComponents: DateComponents!
    var isCellSelectable: Bool?
    var dateCellStyle = DateCellStyle.None{
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        switch dateCellStyle {
        case .CheckInDate:
            CheckInAndOutDateStyleKit.drawCheckInDate(frame: rect)
            break
        case .DateBetweenCheckInAndOutDate:
            CheckInAndOutDateStyleKit.drawDateBetweenCheckInAndOutDate(frame: rect)
            break
        case .CheckOutDate:
            CheckInAndOutDateStyleKit.drawCheckOutDate(frame: rect)
            break
        default:
            break
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        backgroundColor = UIColor.redColor()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lblDay.layer.cornerRadius = frame.size.height / 2
    }

    func selectedForLabelColor() {
        
        lblDay.layer.backgroundColor = UIColor(hex: 0x674290).cgColor
        lblDay.font = UIFont(name: GothamFontName.Bold.rawValue, size: 14)
        lblDay.textColor = UIColor.white
    }
    
    func deselectedForLabel() {
        lblDay.layer.backgroundColor = UIColor.clear.cgColor
        lblDay.font = UIFont(name: GothamFontName.Book.rawValue, size: 14)
        lblDay.textColor = UIColor.black
        dateCellStyle = .None
    }
    
    func disableForLabel() {
        lblDay.textColor = UIColor(hex: 0xD6D6D6)
    }
    
    func visibleForLabel() {
        lblDay.textColor = UIColor.black
    }
    
    
//    func deSelectedForLabelColor(color: UIColor) {
//        self.lblDay.layer.backgroundColor = UIColor.clearColor().CGColor
//        self.lblDay.textColor = color
//    }
    
    
//    func setTodayCellColor(backgroundColor: UIColor) {
//        
//        lblDay.layer.cornerRadius = self.lblDay.frame.size.width/2
//        lblDay.layer.backgroundColor = backgroundColor.CGColor
//        lblDay.textColor  = UIColor.whiteColor()
//    }
}
