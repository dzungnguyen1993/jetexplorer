//
//  DealTableViewCell.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/9/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DealTableViewCell: UITableViewCell {

    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var promoPriceLabel: UILabel!
    @IBOutlet weak var hotelTotalPriceLabel: UILabel!
    @IBOutlet weak var agentImageView: UIImageView!
    @IBOutlet weak var goToAgentLinkButton: SmallParagraphButton!
    
    var agentName : String = "" {
        didSet {
            var agentNameFull = ""
            if !agentName.contains(".") {
                agentNameFull = agentName + ".com"
            }
            goToAgentLinkButton.setTitle("Go to \(agentNameFull)", for: .normal)
        }
    }
    
    var bookingDeepLink : String = "" {
        didSet {
            if bookingDeepLink.contains(".") {
                goToAgentLinkButton.isEnabled = true
            } else {
                goToAgentLinkButton.isEnabled = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(of hotel: HotelinDetail, withPrice price: AgentPrice, fromAgent agent: HotelAgent) {
        
        var showingText = ""
        if let roomType = price.roomOffers.first?.rooms.first?.type {
            showingText = roomType
        }
        
        if let meal = price.roomOffers.first?.mealPlan {
            if showingText == "" {
                showingText = meal
            } else {
                showingText = ("\(showingText) - \(meal)")
            }
        }
        
        if showingText == "" {
            showingText = hotel.name
        }
        
        hotelNameLabel.text = showingText
        agentName = agent.name
        
        let roundedPrice = Int(price.priceTotal + 0.5)
        
        hotelTotalPriceLabel.text = "\(ProfileVC.currentCurrencyType) \(roundedPrice)"
        bookingDeepLink = price.bookingDeepLink
        
        // image
        Alamofire.request(agent.imageUrl).responseImage { response in
            if let image = response.result.value {
               self.agentImageView.image = image
            }
        }
        
        //TODO: ask if promote price is exist?
        promoPriceLabel.text = "\(ProfileVC.currentCurrencyType) \(price.pricePerRoomNight)"
        promoPriceLabel.isHidden = true
    }
    
    @IBAction func goToBookingAgentButtonPressed(_ sender: Any) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: bookingDeepLink)!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(URL(string: bookingDeepLink)!)
        }
    }
    
}
