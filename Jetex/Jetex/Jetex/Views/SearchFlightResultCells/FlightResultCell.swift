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
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var imgClock: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgClock.image = UIImage(fromHex: JetExFontHexCode.jetexClock.rawValue, withColor: UIColor(hex: 0x515151))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func goToExpediaButtonPressed(_ sender: Any) {
//        let cellURL = "https://www.expedia.com/"
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: deepLink)!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(URL(string: deepLink)!)
        }
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
        
        if (leg?.stops.count == 0) {
            lbArrivalTime.text = leg?.arrival.toDateTimeUTC().toShortTimeString()
        } else {
            let arrivalTime = leg?.arrival.toDateTimeUTC().toShortTimeString()
            let arrivalText = arrivalTime! + " +" + (leg?.stops.count.toString())!
            
            let destination = searchResult.getStation(withId: leg!.destinationStation)
            guard destination != nil else {return}
            lbDestinationCode.text = destination?.code
            
            let attributes = [NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!]
            let attributedString = NSMutableAttributedString(string: arrivalText, attributes: attributes)
            let suffixAttributes = [NSForegroundColorAttributeName: UIColor(hex: 0xE8615B),
                                    NSFontAttributeName: UIFont(name: GothamFontName.Book.rawValue, size: 12)!]
            attributedString.addAttributes(suffixAttributes, range: NSRange(location: (arrivalTime?.characters.count)!, length: arrivalText.characters.count - (arrivalTime?.characters.count)!))
            
            lbArrivalTime.attributedText = attributedString     
        }
        
        // show duration
        lbDuration.text = leg?.duration.toHourAndMinute()
        
        // show price
        lbPrice.text = searchResult.query.currency + " " + String(format: "%.0f", (itinerary.pricingOptions.first?.price)!)
        
        // show carrier
        let carrier = searchResult.getCarrier(withId: (leg?.carriers.first)!)
        lbCarrier.text = carrier?.name
        
//        // download carrier image
//        Alamofire.request((carrier?.imageUrl)!).responseImage { response in
//            if let image = response.result.value {
//                let ratio = image.size.width / image.size.height
//             
//                // remove old constraint
//                self.imgCarrier.removeConstraint(self.constraintLogoRatio)
//                
//                self.constraintLogoRatio = NSLayoutConstraint(item: self.imgCarrier, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.imgCarrier, attribute: NSLayoutAttribute.height, multiplier: ratio, constant: 0)
//                self.imgCarrier.addConstraint(self.constraintLogoRatio)
//                
//                self.imgCarrier.image = image
//            }
//        }
        
        // add stop view (dots) on the line
        for view in self.viewInfoGeneral.subviews {
            if view.isKind(of: StopViewSmall.self) {
                view.removeFromSuperview()
            }
        }
        
        var totalDuration = 0
        for segmentId in (leg?.segmentIds)! {
            let segment = searchResult.getSegment(withId: segmentId)
            
            totalDuration = totalDuration + (segment?.duration)!
        }
        
        var sum = 0

        var minStop = leg?.stops.count
        if minStop! > 3 {
            minStop = 3
        }
        
        var lastX: CGFloat = 0
        for i in 0..<minStop! {
//        for i in 0..<(leg?.stops.count)! {
            let stopId = leg?.stops[i]
        
            let place = searchResult.getStation(withId: stopId!)
            
            let segment = searchResult.getSegment(withId: (leg?.segmentIds[i])!)
            let ratio = CGFloat((segment?.duration)! + sum) / CGFloat(totalDuration)
            sum = sum + (segment?.duration)!
            
            
            var x = self.viewLine.frame.origin.x + self.viewLine.frame.size.width * ratio - 17
            if (x - lastX) < 20 {
                x = x + 20
            }
            lastX = x
            
            if x + 34 < self.viewLine.frame.origin.x + self.viewLine.frame.size.width {
                let rect = CGRect(x: self.viewLine.frame.origin.x + self.viewLine.frame.size.width * ratio - 17, y: self.viewLine.frame.origin.y - 19, width: 34, height: 25)
                
                let stopView = StopViewSmall(frame: rect, airportName: (place?.code)!)
                
                self.viewInfoGeneral.addSubview(stopView)
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
