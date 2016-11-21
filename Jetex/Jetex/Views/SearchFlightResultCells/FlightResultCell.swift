//
//  FlightResultCell.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/16/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class FlightResultCell: UITableViewCell {

    @IBOutlet weak var viewInfoGeneral: UIView!
    @IBOutlet weak var viewDepart: UIView!
    @IBOutlet weak var viewReturn: UIView!
    @IBOutlet weak var viewDetails: UIView!
    
    @IBOutlet weak var constraintDepartHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintReturnHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintDetailsHeight: NSLayoutConstraint!
    
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addViewDetails(flightInfo: FlightInfo) {
        // remove sub view
        for view in self.subviews {
            if (view.isKind(of: FlightResultDetailsView.self)) {
                view.removeFromSuperview()
            }
        }
        
        // add view depart
        addViewDepart(flightInfo: flightInfo)
        
        // add view return
        addViewReturn(flightInfo: flightInfo)
        
        // set height
        constraintDetailsHeight.constant = CGFloat(FlightCellUtils.heightForDetailsOfFlightInfo(flightInfo: flightInfo))
    }
    
    private func addViewDepart(flightInfo: FlightInfo) {
        let height = FlightCellUtils.heightForDepartOfFlight(flightInfo: flightInfo)
        
        let viewDetailsDepart = FlightResultDetailsView(frame: CGRect(x: 0, y: 0, width: Int(self.viewDepart.frame.width), height: height))
        
        viewDetailsDepart.addDetails(flightInfo: flightInfo)
        // add border
        viewDetailsDepart.layer.borderColor = UIColor(hex: 0x515151).cgColor
        viewDetailsDepart.layer.borderWidth = 1.0
        
        self.viewDepart.addSubview(viewDetailsDepart)
        constraintDepartHeight.constant = CGFloat(height)
    }
    
    private func addViewReturn(flightInfo: FlightInfo) {
        let height = FlightCellUtils.heightForReturnOfFlight(flightInfo: flightInfo)
        
        let viewReturnDetails = FlightResultDetailsView(frame: CGRect(x: 0, y: 0, width: Int(self.viewReturn.frame.width), height: height))
        
        viewReturnDetails.addDetails(flightInfo: flightInfo)
        // add border
        viewReturnDetails.layer.borderColor = UIColor(hex: 0x515151).cgColor
        viewReturnDetails.layer.borderWidth = 1.0
        
        self.viewReturn.addSubview(viewReturnDetails)
        constraintReturnHeight.constant = CGFloat(height)
    }
    
    @IBAction func goToExpediaButtonPressed(_ sender: Any) {
        let cellURL = "https://www.expedia.com/"
        UIApplication.shared.open(URL(string: cellURL)!, options: [:], completionHandler: nil)
    }
}
