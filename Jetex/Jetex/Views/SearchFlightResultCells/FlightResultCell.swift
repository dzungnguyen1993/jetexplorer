//
//  FlightResultCell.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/16/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FlightResultCell: UITableViewCell {

    @IBOutlet weak var viewInfoGeneral: UIView!
    @IBOutlet weak var viewDepart: UIView!
    @IBOutlet weak var viewReturn: UIView!
    @IBOutlet weak var viewDetails: UIView!
    
    @IBOutlet weak var constraintDepartHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintReturnHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintLogoRatio: NSLayoutConstraint!
    
    @IBOutlet weak var containerView: UIView!
 
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbFlightType: UILabel!
    @IBOutlet weak var imgCarrier: UIImageView!
    @IBOutlet weak var lbCarrier: GothamBold17Label!
    
    @IBOutlet weak var lbOriginCode: UILabel!
    @IBOutlet weak var lbDestinationCode: UILabel!
    @IBOutlet weak var lbDepartureTime: UILabel!
    @IBOutlet weak var lbArrivalTime: UILabel!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var btnDeeplink: SmallParagraphButton!
    var deepLink: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func goToExpediaButtonPressed(_ sender: Any) {
//        let cellURL = "https://www.expedia.com/"
        UIApplication.shared.open(URL(string: deepLink)!, options: [:], completionHandler: nil)
    }
}

// MARK: show info
extension FlightResultCell {
    func showInfo(ofSearchResult searchResult: SearchFlightResult, forItinerary itinerary: Itinerary) {
        showInfoGeneral(ofSearchResult: searchResult, forItinerary: itinerary)
    }
    
    func showInfoGeneral(ofSearchResult searchResult: SearchFlightResult, forItinerary itinerary: Itinerary) {
        if (itinerary.inboundLegId != "") {
            self.lbFlightType.text = "Roundtrip"
        } else {
            self.lbFlightType.text = "One-way"
        }
        
        let leg = searchResult.getLeg(withId: itinerary.outboundLegId)
        guard leg != nil else {return}
        
        // show origin
        let origin = searchResult.getStation(withId: leg!.originStation)
        guard origin != nil else {return}
        lbOriginCode.text = origin?.code
        lbDepartureTime.text = leg?.departure.toDateTimeUTC().toShortTimeString()
        
        // show destination
        let destination = searchResult.getStation(withId: leg!.destinationStation)
        guard destination != nil else {return}
        lbDestinationCode.text = destination?.code
        lbArrivalTime.text = leg?.arrival.toDateTimeUTC().toShortTimeString()
        
        // show duration
        lbDuration.text = leg?.duration.toHourAndMinute()
        
        // show price
        lbPrice.text = searchResult.query.currency + " " + String(format: "%.1f", (itinerary.pricingOptions.first?.price)!)
        
        // show carrier
        let carrier = searchResult.getCarrier(withId: (leg?.carriers.first)!)
        lbCarrier.text = carrier?.name
        
        // download carrier image
        Alamofire.request((carrier?.imageUrl)!).responseImage { response in
            if let image = response.result.value {
                let ratio = image.size.width / image.size.height
                
                // remove old constraint
                self.imgCarrier.removeConstraint(self.constraintLogoRatio)
                
                self.constraintLogoRatio = NSLayoutConstraint(item: self.imgCarrier, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.imgCarrier, attribute: NSLayoutAttribute.height, multiplier: ratio, constant: 0)
                self.imgCarrier.addConstraint(self.constraintLogoRatio)
                
                self.imgCarrier.image = image
            }
        }
    }
}

// MARK: show details
extension FlightResultCell {
    func addDetails(ofSearchResult searchResult: SearchFlightResult, forItinerary itinerary: Itinerary) {
        // add btnDeeplink
        let pricingOption = itinerary.pricingOptions.first
        deepLink = (pricingOption?.deeplinkUrl)!
        let agent = searchResult.getAgent(withId: (pricingOption?.agents.first)!)
        btnDeeplink.setTitle("Go to " + (agent?.name)!, for: .normal)
        
        // remove sub view
        for view in self.viewDepart.subviews {
            if (view.isKind(of: FlightResultDetailsView.self)) {
                view.removeFromSuperview()
            }
        }
        
        for view in self.viewReturn.subviews {
            if (view.isKind(of: FlightResultDetailsView.self)) {
                view.removeFromSuperview()
            }
        }
        
        // add view depart
        let legDepart = searchResult.getLeg(withId: itinerary.outboundLegId)
        guard legDepart != nil else {
            constraintDepartHeight.constant = 0
            return
        }
        
        let departHeight = FlightCellUtils.heightForLeg(leg: legDepart)
        constraintDepartHeight.constant = CGFloat(departHeight)
        addViewDetails(ofSearchResult: searchResult, forLeg: legDepart!, forView: viewDepart)
        
        // add view return
        let legReturn = searchResult.getLeg(withId: itinerary.inboundLegId)
        guard legReturn != nil else {
            constraintReturnHeight.constant = 0
            constraintDetailsHeight.constant = CGFloat(FlightCellUtils.heightForDetailsOfFlightInfo(legDepart: legDepart, legReturn: legReturn))
            return
        }
        
        let returnHeight = FlightCellUtils.heightForLeg(leg: legReturn)
        constraintReturnHeight.constant = CGFloat(returnHeight)
        addViewDetails(ofSearchResult: searchResult, forLeg: legReturn!, forView: viewReturn)
        
        constraintDetailsHeight.constant = CGFloat(FlightCellUtils.heightForDetailsOfFlightInfo(legDepart: legDepart, legReturn: legReturn))
    }
    
    private func addViewDetails(ofSearchResult searchResult: SearchFlightResult, forLeg leg: Leg, forView view: UIView) {
        let height = FlightCellUtils.heightForLeg(leg: leg)
        
        let viewDetailsDepart = FlightResultDetailsView(frame: CGRect(x: 0, y: 0, width: Int(view.frame.width), height: height))
        
        viewDetailsDepart.addDetails(ofSearchResult: searchResult, forLeg: leg)
        
        // add border
        viewDetailsDepart.layer.borderColor = UIColor(hex: 0xD6D6D6).cgColor
        viewDetailsDepart.layer.borderWidth = 1.0
        
        view.addSubview(viewDetailsDepart)
    }
}
