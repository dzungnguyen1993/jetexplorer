//
//  UICheckBoxButton.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 11/15/16.
//  Copyright © 2016 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

class UICheckBoxButton: UIButton {

    @IBOutlet var view: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    var isChecked : Bool {
        set {
            if newValue {
                // check
            } else {
                // uncheck
            }
            self.isChecked = newValue
        }
        get {
            return self.isChecked
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let view: UIView = Bundle.main.loadNibNamed("UICheckBoxButton", owner: self, options: nil)!.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}
