//
//  ApplyFilterView.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/20/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

protocol ApplyFilterViewDelegate: class {
    func clickApply()
}

class ApplyFilterView: UITableViewCell {

    weak var delegate: ApplyFilterViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func applyFilter(_ sender: UIButton) {
        delegate?.clickApply()
    }
}
