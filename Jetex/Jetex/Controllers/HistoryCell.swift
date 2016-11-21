//
//  FlightHistoryCell.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    static let CellHeight : CGFloat = 92.0
    
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
        if data.searchType == .Flight {
            self.fillDataForFlight(data: data as! FlightHistorySearch)
        } else if data.searchType == .Hotel {
            self.fillDataForHotel(data: data as! HotelHistorySearch)
        }
        
        // TODO : show start - end day
        
        // TODO: show options
        
        // TODO: show searching time
    }
    
    func fillDataForFlight(data: FlightHistorySearch) {
        historyTypeImageView.image = UIImage(fromHex: JetExFontHexCode.planeEmpty.rawValue, withColor: UIColor(hex: 0x674290))
        
        fromLabel.text = data.from.cityName
        toLabel.text = data.to.cityName
        
        if data.isRoundTrip != nil && data.isRoundTrip == true {
            exchangeLabel.text = "\(NSString.init(utf8String: JetExFontHexCode.exchange.rawValue)!)"
        } else {
            exchangeLabel.text = "\(NSString.init(utf8String: JetExFontHexCode.oneWay.rawValue)!)"
        }
    }
    
    func fillDataForHotel(data: HotelHistorySearch) {
        historyTypeImageView.image = UIImage(fromHex: JetExFontHexCode.bedEmpty.rawValue, withColor: UIColor(hex: 0x674290))
        
        fromLabel.text = data.hotelName
        exchangeLabel.text = ""
        toLabel.text = ""
    }
    
}
