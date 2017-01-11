//
//  ReviewTableCellTableViewCell.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/10/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class ReviewTableCellTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewNameLabel: UILabel!
    @IBOutlet weak var reviewScoreLabel: UILabel!
    @IBOutlet weak var reviewScoreProgress: UIProgressView!
    
    public var reviewName: String = "Review" {
        didSet {
            reviewNameLabel.text = reviewName
        }
    }
    
    public var reviewScore: Float = 10.0 {
        didSet {
            reviewScoreLabel.text = "\(reviewScore)"
            reviewScoreProgress.progress = reviewScore / 10.0
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
    
}
