//
//  FlightHistoryCell.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    static let CellHeight : CGFloat = 88.0
    
    var data : HistorySearch!
    var searchedType : HistorySearchType!
    
    @IBOutlet weak var historyTypeImageView: UIImageView!

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var exchangeLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var optionsLabel: UILabel!
    
    @IBOutlet weak var searchedTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        searchedType = .Flight
        exchangeLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func fillData(data: HistorySearch) {
        self.data = data
        if data.dataType == .Flight {
            self.fillDataForFlight(data: data.flightHistory!)
        } else if data.dataType == .Hotel {
            self.fillDataForHotel(data: data.hotelHistory!)
        }
        
        // Show searching time
        searchedTimeLabel.text = data.createTime.howlongago()
    }
    
    func fillDataForFlight(data: FlightHistorySearch) {
        historyTypeImageView.image = UIImage(fromHex: JetExFontHexCode.planeEmpty.rawValue, withColor: UIColor(hex: 0x674290))
        
        fromLabel.text = data.departAirport
        fromLabel.resizeToFitText()
        toLabel.text = data.arrivalAirport
        toLabel.resizeToFitText()
        
        
        //show start - end day
        timeLabel.resizeToFitText()
        exchangeLabel.resizeToFitText()
        
        if data.isRoundTrip == true {
            exchangeLabel.text = "\(NSString.init(utf8String: JetExFontHexCode.exchange.rawValue)!)"
            timeLabel.text = "\(Date.shorterlizeFullMonthDay(data.departDateText)) - \(Date.shorterlizeFullMonthDay(data.returnDateText))"
        } else {
            exchangeLabel.text = "\(NSString.init(utf8String: JetExFontHexCode.oneWay.rawValue)!)"
            timeLabel.text = "\(Date.shorterlizeFullMonthDay(data.departDateText))"
        }
        
        // options
        var option = ""
        let passenger = data.adult + data.children + data.infant
        option += ", \(passenger) \(passenger > 1 ? "people" : "person")"
        option += (data.flightClass != "" ? ", \(data.flightClass)" : "")
        
        optionsLabel.text = option
        optionsLabel.resizeToFitText()
    }
    
    func fillDataForHotel(data: HotelHistorySearch) {
        historyTypeImageView.image = UIImage(fromHex: JetExFontHexCode.bedEmpty.rawValue, withColor: UIColor(hex: 0x674290))
        
        fromLabel.text = data.hotelName
        exchangeLabel.text = ""
        toLabel.text = ""
        
        //show start - end day
        timeLabel.resizeToFitText()
        exchangeLabel.text = ""
        timeLabel.text = "\(Date.shorterlizeFullMonthDay(data.checkinDateText)) - \(Date.shorterlizeFullMonthDay(data.checkoutDateText))"
        
        // options
        var option = ""
        option += ", \(data.numberOfGuests) \(data.numberOfGuests > 1 ? "guests" : "guest")"
        option += ", \(data.numberOfRooms) \(data.numberOfRooms > 1 ? "rooms" : "room")"
        
        optionsLabel.text = option
        optionsLabel.resizeToFitText()
    }
    
}
