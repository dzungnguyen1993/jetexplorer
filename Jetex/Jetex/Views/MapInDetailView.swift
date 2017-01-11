//
//  MapInDetailView.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/10/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class MapInDetailView: UIView {

    static let height : CGFloat = 400.0
    
    @IBOutlet var contentView: UIView!
    
    func initView() {
        Bundle.main.loadNibNamed("MapInDetailView", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

}
