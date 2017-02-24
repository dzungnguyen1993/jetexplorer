//
//  UITabbarButton.swift
//  Jetex
//
//  Created by NguyenXuan-Gieng on 1/8/17.
//  Copyright © 2017 Thanh-Dung Nguyen. All rights reserved.
//

import UIKit

@IBDesignable class UITabbarButton: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var titleLable: UILabel!
    @IBOutlet var bottomLine: UIView!
    
    @IBInspectable var title: String = "Button" {
        didSet {
            titleLable.text = title
        }
    }
    
    @IBInspectable var isSelected: Bool = false {
        didSet {
            if isSelected != oldValue {
                // animate
                if isSelected {
                    UIView.animate(withDuration: 0.25, animations: { 
                        // bold the text
                        self.titleLable.font = UIFont(name: GothamFontName.Bold.rawValue, size: 12)
                        self.titleLable.textColor = UIColor(hex: 0x674290)
                        
                        // show the bottom line
                        self.bottomLine.alpha = 1.0
                    })
                } else {
                    UIView.animate(withDuration: 0.25, animations: { 
                        // normal the text
                        self.titleLable.font = UIFont(name: GothamFontName.Book.rawValue, size: 12)
                        self.titleLable.textColor = UIColor(hex: 0x706F73)
                        
                        // hide the bottom line
                        self.bottomLine.alpha = 0.0
                    })
                }
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        Bundle.main.loadNibNamed("UITabbarButton", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
    }
    
    init(frame: CGRect, airportName: String) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("UITabbarButton", owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.contentView]))
        
        
    }
}
