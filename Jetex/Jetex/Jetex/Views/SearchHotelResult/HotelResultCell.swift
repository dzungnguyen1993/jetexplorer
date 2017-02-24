//
//  HotelResultCell.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 12/19/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class HotelResultCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var hotelImg: UIImageView!
    @IBOutlet weak var lbPopularity: PaddingLabel!
    @IBOutlet weak var lbPriceOrigin: UILabel!
    @IBOutlet weak var lbHotelName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var lbPricePerNight: UILabel!
    @IBOutlet var stars: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showStars(star: Int) {
        for i in 0..<stars.count {
            let imageView = stars[i]
            if i < star {
                imageView.isHidden = false
                imageView.image = UIImage(fromHex: JetExFontHexCode.jetexStarFulfill.rawValue, withColor: (UIColor(hex: 0x674290)))
            } else {
                imageView.isHidden = true
            }
        }
    }
}
