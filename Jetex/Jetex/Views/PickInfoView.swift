//
//  PickInfoView.swift
//  Jetex
//
//  Created by Thanh-Dung Nguyen on 11/11/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class PickInfoView: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbInfo: UILabel!
    @IBOutlet weak var lbSubInfo: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        Bundle.main.loadNibNamed("PickInfoView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
    }
}
