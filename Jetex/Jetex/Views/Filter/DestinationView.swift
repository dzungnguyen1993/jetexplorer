//
//  DestinationView.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class DestinationView: UITableViewCell {

    @IBOutlet weak var checkOriginBtn: UIImageView!
    @IBOutlet weak var checkOriginLb: UILabel!
    
    @IBOutlet weak var checkDestinationBtn: UIImageView!
    @IBOutlet weak var checkDestinationLb: UILabel!
    
    var isOriginSelected = false
    var isDestinationSelected = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checkOrigin(_ sender: UIButton) {
        isOriginSelected = !isOriginSelected
        
        if (isOriginSelected) {
            checkOriginBtn.image = UIImage(named: "check rect")
            checkOriginLb.textColor = UIColor(hex: 0x674290)
        } else {
            checkOriginBtn.image = UIImage(named: "uncheck rect")
            checkOriginLb.textColor = UIColor(hex: 0x515151)
        }
    }
    
    @IBAction func checkDestination(_ sender: UIButton) {
        isDestinationSelected = !isDestinationSelected
        
        if (isDestinationSelected) {
            checkDestinationBtn.image = UIImage(named: "check rect")
            checkDestinationLb.textColor = UIColor(hex: 0x674290)
        } else {
            checkDestinationBtn.image = UIImage(named: "uncheck rect")
            checkDestinationLb.textColor = UIColor(hex: 0x515151)
        }
    }
    
}
